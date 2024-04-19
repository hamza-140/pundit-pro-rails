# app/mailers/notification_mailer.rb
class NotificationMailer < ApplicationMailer
  def bug_assignment_notification(user, bug)
    @user = user
    @bug = bug
    creator_id = @bug.created_by # Assuming @bug.created_by gives the creator's ID
    @creator_bug = User.find(creator_id) # Assuming User is the model representing users
    # mail(to: "sahamzashah19@gmail.com", subject: "Hi",body: "hee")
    mail(to: @user.email, subject: 'Bug Assignment Notification')

  end

  def project_assignment_notification(user, assignment)
    @user = user
    @project = assignment
    mail(to: @user.email, subject: 'You have been added to a project')
    end
end
