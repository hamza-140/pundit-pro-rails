# app/policies/bug_policy.rb
class BugPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present? && ((user.role == "manager" && record.project.created_by == user.id) || # Managers can see all bugs in the project they created
                      (user.role == "developer" && record.project.users.include?(user)) || # Developers can see bugs if they are part of the project
                      (user.role == "quality_assurance" && record.project.users.include?(user)) # Quality assurance users can see bugs if they are part of the project
      )
  end

  def create?
    # puts "in create"
    # puts record.project.created_by
    user.present? && ((user.role == "quality_assurance" && record.project.users.include?(user)) || (user.role == "manager" && record.project.created_by == user.id))
  end

  def update?
    user.present? && ((user.role == "manager" && record.created_by == user.id) || # Managers can see all bugs in the project they created
                      (user.role == "developer" && record.project.users.include?(user)) || # Developers can see bugs if they are part of the project
                      (user.role == "quality_assurance" && record.created_by == user.id) # Quality assurance users can see bugs if they are part of the project
      )
  end

  def edit?
    user.present? && ((user.role == "manager" && record.created_by == user.id) || # Managers can see all bugs in the project they created
                      (user.role == "developer" && record.project.users.include?(user)) || # Developers can see bugs if they are part of the project
                      (user.role == "quality_assurance" && record.created_by == user.id) # Quality assurance users can see bugs if they are part of the project
      )
  end

  def destroy?
    user.present? && record.created_by == user.id # Quality assurance users can see bugs if they are part of the project
  end

  class Scope < Scope
    def resolve
      if user.present? && user.role == "manager"
        scope.where(created_by: user.id)
      elsif user.present? && user.role == "developer"
        scope.all
      elsif user.present? && user.role == "quality_assurance"
        scope.where(created_by: user.id)
      else
        scope.none
      end
    end
  end
end
