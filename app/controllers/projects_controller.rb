class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def search
    @projects = policy_scope(Project).order(created_at: :desc)

    query = params[:q].to_s.strip
    @items = @projects.where("name LIKE ?", "%#{query}%")

    render json: { projects: @items }, status: :ok
  end

  def all
    @projects = policy_scope(Project).order(created_at: :desc)

    render json: { projects: @projects }, status: :ok
  end

  def index
    @projects = policy_scope(Project).order(created_at: :desc)
    query = params[:q]
    @items = @projects.where("name LIKE ?", "%#{query}%")
  end

  def bugs
    @projects = current_user.projects
    authorize @projects
  end

  def create
    @project = Project.new(project_params)
    @project.users << current_user
    @project.created_by = current_user.id

    if current_user.role == "manager"
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
    else
      render :unauthorized, status: :unauthorized
    end
  rescue ActiveRecord::RecordNotUnique => e
    @project.errors.add(:base, "A bug with the same title already exists.")
    render :new, status: :unprocessable_entity
  end


  def update
    authorize @project

    # Store the current user IDs before updating the project
    current_user_ids = @project.project_users.pluck(:user_id)
    puts "current users"
    print(current_user_ids)
    if @project.update(project_params)
      # Determine newly added users
      new_user_ids = @project.project_users.pluck(:user_id) - current_user_ids
      puts "new users"
      print(new_user_ids)
      # Send notification to newly added users
      new_user_ids.each do |user_id|
        SendNotificationJob.perform_later([user_id], :project_assignment, @project)
      end

      # Remove user from associated bugs if they are removed from the project
      removed_user_ids = current_user_ids - @project.project_users.pluck(:user_id)
      puts "removed users"
      print(removed_user_ids)
      removed_user_ids.each do |user_id|
        removed_user_bugs = @project.bugs.where(user_id: user_id)
        removed_user_bugs.update_all(user_id: nil)
      end

      redirect_to @project, notice: "Project updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end





  def destroy
    authorize @project
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
    @project.project_users.build
    authorize @project
  end

  def edit
    # @project = Project.find(params[:id])
    authorize @project
    puts "in edit"
    puts @project.inspect # Add this line for debugging
  end

  def users
    puts "in users"
    puts params.inspect # Output params to the console
    query = params[:q]
    @users = User.where("email LIKE ?", "%#{query}%")

    begin
      @pagy, @users = pagy(@users)
    rescue Pagy::Error => e
      flash.now[:alert] = "Pagy error: #{e.message}"
      @users = User.none
    end

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
      project_users_attributes: [:id,:project_id, :user_id,:_destroy],
      users_attributes: [:id, :name, :email],
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
