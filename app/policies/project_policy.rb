# app/policies/project_policy.rb
class ProjectPolicy < ApplicationPolicy
  attr_reader :user, :project

  def initialize(user, project)
    @user = user
    @project = project
  end

  def index?
    user.present?
  end

  def show?
    user_is_allowed?
  end

  def edit?
    user_is_creator?
  end

  def destroy?
    user.present? && user.role == "manager"
  end

  def create?
    user.present? && user.role == "manager"
  end

  def bugs?
    user.present?
  end

  def update?
    user.present? && user.role == "manager" && (record.users.include?(user) || record.created_by == user.id)
  end

  def destroy?
    user.present? && user.role == "manager" && record.users.include?(user)
  end

  class Scope < Scope
    def resolve
      if user.present? && user.role == "manager"
        scope.where(created_by: user.id).or(scope.where(id: user.projects.pluck(:id)))
      elsif user.present? && user.role == "developer"
        scope.where(id: user.projects.pluck(:id))
      elsif user.present? && user.role == "quality_assurance"
        scope.where(id: user.projects.pluck(:id))
      else
        scope.none
      end
    end
  end

  def user_is_allowed?
    project.created_by == user.id || project.users.include?(user)
  end

  def user_is_creator?
    project.created_by == user.id
  end
end
