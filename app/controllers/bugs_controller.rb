class BugsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_bug, only: [:show, :edit, :update, :destroy]

  def index
    authorize @project, :show?
    @bugs = @project.bugs.all
  end

  def create
    @bug = @project.bugs.new(bug_params)
    @bug.created_by = current_user.id

    if @bug.save
      user_id = params[:bug][:user_id]
    unless user_id.blank?
      SendNotificationJob.perform_later([user_id], :bug_assignment, @bug)
    end
      redirect_to project_bug_path(@project, @bug), notice: "Bug created successfully."
    else
      render :new , status: :unprocessable_entity
    end
  end



  def update
    authorize @bug
    if @bug.update(bug_params)
      user_id = params[:bug][:user_id]
      unless user_id.blank?
        SendNotificationJob.perform_later([user_id], :bug_assignment, @bug)
      end
      if params[:bug][:remove_screenshot].present?
        @bug.screenshot = nil
        @bug.save
      end
      redirect_to project_bug_path(@project, @bug), notice: "Bug updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @bug
    @bug.destroy
    redirect_to project_path(@project), notice: "Bug deleted successfully."
  end

  def delete_screenshot
    @bug = Bug.find(params[:id])
    @bug.update(screenshot: nil) # Assuming `screenshot` is the name of the column
    # redirect_to @bug, notice: 'Screenshot was successfully cleared.'
  end
  def show
    authorize @bug
  end

  def new
    @bug = @project.bugs.new
    authorize @bug
  end

  def edit
    authorize @bug
  end
  def remove_screenshot
    # @bug.screenshot = nil
    print("============================================================")
    print("============================================================")

    # @bug.save
    # redirect_to edit_project_bug_path(@bug), notice: "Screenshot removed successfully."
  end
  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_bug
    @bug = @project.bugs.find(params[:id])
  end

  def bug_params
    params.require(:bug).permit(:title, :description, :user_id, :deadline, :screenshot, :bug_type, :status,:remove_screenshot)
  end

end
