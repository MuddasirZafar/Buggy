class MyBugsController < ApplicationController
  before_action :authorize_create_bug, only: [:new, :create]
  before_action :find_bug, only: [:show, :edit, :update, :destroy]
  before_action :authorize_update_bug, only: [:edit, :update, :destroy]

  def index
    flash[:danger] = "Bugs have no existence without a project"
    redirect_to projects_path
  end

  def new
    @project_id = params[:project_id]
    @bug = MyBug.new if @project_id.present?
  end

  def create
    @bug = MyBug.new(bug_params)
    if @bug.save
      redirect_to project_path(@bug.project_id), success: "Bug created successfully"
    else
      flash.now[:danger] = "Request failed..."
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @bug.update(bug_params)
      redirect_to my_bug_path(@bug), success: "Updated successfully"
    else
      flash[:danger] = "Update failed... try again later.."
      render 'edit'
    end
  end

  def bug_status
    @bug.update(status: params[:status])
    render json: { success: "ok" }
  end

  def destroy
    if @bug.destroy
      redirect_to my_bugs_path, success: "Deleted successfully"
    else
      flash[:danger] = "Something went wrong..."
      render 'show'
    end
  end

  private

  def authorize_create_bug
    unless can?(:create, MyBug)
      flash[:danger] = "Only Manager or QA can create a bug"
      redirect_to root_path
    end
  end

  def find_bug
    @bug = MyBug.find(params[:id])
  end

  def authorize_update_bug
    unless can_update_bug(@bug.project.id)
      flash[:danger] = "Only project-related personnel can make changes"
      redirect_to root_path
    end
  end

  def bug_params
    params.require(:my_bug).permit(:title, :description, :assigned_to, :status, :bug_type, :project_id, :user_id, :deadline, :image)
  end
end
