# app/jobs/send_notification_job.rb
class SendNotificationJob < ApplicationJob
  queue_as :default

  def perform(user_ids, assignment_type, assignment)
    case assignment_type
    when :bug_assignment
      user = User.find(user_ids.first)
      @bug = assignment
      creator_id = @bug.created_by # Assuming @bug.created_by gives the creator's ID
      @creator_bug = User.find(creator_id)
      NotificationMailer.bug_assignment_notification(@creator_bug, assignment).deliver_now
      NotificationMailer.bug_assignment_notification(user, assignment).deliver_now
    when :project_assignment
      users = User.where(id: user_ids)
      users.each do |user|
        NotificationMailer.project_assignment_notification(user, assignment).deliver_now
      end
    else
      # Handle unsupported assignment types
    end
  end
end
