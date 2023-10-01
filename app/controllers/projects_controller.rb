class ProjectsController < ApplicationController
  before_action :find_project, only: [:show, :edit, :update, :destroy]
  before_action :authorize_manager, only: [:new, :create, :edit, :update, :destroy]
  before_action :authorize_project_creator, only: [:edit, :update]
  
  def new
    @project = Project.new
    @dev = User.where(user_type: "developer")
    @qa = User.where(user_type: "qa")
  end
  
  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id
  
    if @project.save
      redirect_to project_path(@project), notice: "Project created successfully."
    else
      flash.now[:danger] = "Failed to create project."
      render :new
    end
  end
  
  def show
    unless can_update_bug(@project.id)
      flash[:danger] = "Access Denied"
      redirect_to projects_path
    end
  end
  
  def edit
  end
  
  def update
    if @project.update(project_params)
      redirect_to project_path(@project), notice: "Project updated successfully."
    else
      flash.now[:danger] = "Failed to update project."
      render :edit
    end
  end
  
  def destroy
    if @project.destroy
      redirect_to projects_path, notice: "Project deleted successfully."
    else
      flash[:danger] = "Failed to delete project."
      redirect_to projects_path
    end
  end
  
  def index
    @projects = current_user.projects
    @projects = Project.where(user_id: current_user.id) if current_user.user_type == 'manager'
  end
  
  private
  
  def project_params
    params.require(:project).permit(:name, :description, user_ids: [])
  end
  
  def find_project
    @project = Project.find(params[:id])
  end
  
  def authorize_manager
    unless can? :create, Project
      flash[:danger] = "Only manager can create, edit, or delete projects."
      redirect_to root_path
    end
  end
  
  def authorize_project_creator
    unless can?(:update, @project) || @project.user_id == current_user.id
      flash[:danger] = "Only manager and project creator can edit the project."
      redirect_to root_path
    end
  end
end
