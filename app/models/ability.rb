# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.present?
      if user.manager?
        can [:read,:create] , Project
        can [:update,:destroy], Project, :user_id => user.id
        can [:create,:read,:update] , MyBug
        can :destroy, MyBug , user_id: user.id
      end
      if user.qa?
        can :read, Project
        can [:create,:read,:update] , MyBug
        can :destroy, MyBug , user_id: user.id
      end
      if user.developer?
        can :read, Project
        can :read, MyBug
        can :update, MyBug , assigned_to: user.id
      end
    else
      can :read, :all
    end
  end
end
