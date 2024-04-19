class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    # puts params.inspect # Add this line for debugging
    @projects = policy_scope(Project).order(created_at: :desc)
    @query = params[:q]
    @items = @projects.where("name LIKE ?", "%#{@query}%")
    @pagy, @items = pagy(@items)
    authorize @projects
  end

  def bugs
    @projects = current_user.projects
    authorize @projects
  end

  def create
    @project = Project.new(project_params)
    @project.users << current_user
    @project.created_by = current_user.id
    # @project.bugs.created_by = current_user.id

    authorize @project

    if @project.save
      if params[:user_ids].present?
        user_ids = params[:user_ids].reject(&:empty?)
        user_ids.each do |user_id|
          @project.users << User.find(user_id)
        end
      end
      SendNotificationJob.perform_later(@project.users.pluck(:id), :project_assignment, @project)
      redirect_to @project, notice: "Project created successfully."
    else
      @users = User.all
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique => e
    @project.errors.add(:base, "A bug with the same title already exists.")
    render :new, status: :unprocessable_entity
  end

  def update
    # Store the current users before updating the project
    current_user_ids = @project.user_ids

    if @project.update(project_params)
      # Determine newly added users
      new_user_ids = @project.user_ids - current_user_ids
      # Send notification to newly added users
      new_user_ids.each do |user_id|
        SendNotificationJob.perform_later([user_id], :project_assignment, @project)
      end
      # SendNotificationJob.perform_later(new_users.pluck(:id), :project_assignment, @project)

      redirect_to @project, notice: "Project updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_url, notice: "Project deleted successfully."
  end

  def show
    authorize @project
    @bug = Bug.new(project: @project)

    if current_user.role == "quality_assurance"
      @bugs = policy_scope(@project.bugs)
    else
      @bugs = @project.bugs.all
    end

    # authorize @bugs
  end

  def new
    @project = Project.new
    @users = User.all
    @bug = Bug.new(project: @project)
    @project.bugs.build
    @bug.created_by = current_user.id
    authorize @project
  end

  def edit
    # @project = Project.find(params[:id])
    authorize @project
    puts "in edit"
    puts @project.inspect # Add this line for debugging
  end

  def users
    @pagy, @users = pagy(User.all)
    # @users = User.all
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :name,
      :q,
      :description,
      :created_by,
      user_ids: [],
      bugs_attributes: [:id, :title, :description, :user_id, :deadline, :screenshot, :bug_type, :status],
    ).tap do |whitelisted|
      if whitelisted[:bugs_attributes].present?
        whitelisted[:bugs_attributes].each do |_, bug_attributes|
          bug_attributes[:created_by] = current_user.id
        end
      end
    end
  end
end
