class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :manager?, :qa?, :can_create_bug?, :can_update_bug

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :user_type])
  end

  def manager?
    user_signed_in? && current_user.user_type == "manager"
  end

  def qa?
    user_signed_in? && current_user.user_type == "qa"
  end

  def can_create_bug?(project_id)
    project = Project.find_by(id: project_id)

    return false unless project

    if manager? && project.user_id == current_user.id
      true
    elsif qa? && UsersProject.exists?(project_id: project_id, user_id: current_user.id)
      true
    else
      false
    end
  end

  def can_update_bug(project_id)
    project = Project.find_by(id: project_id)

    return false unless project

    UsersProject.exists?(project_id: project_id, user_id: current_user.id) ||
      project.user_id == current_user.id
  end
end
