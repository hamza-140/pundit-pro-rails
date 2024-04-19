# class UserMailer < ApplicationMailer
#   def welcome_email(user)
#     @user = user
#     mail(to: @user.email, subject: 'Welcome to BugMe! 🐞') do |format|
#       format.html { render layout: 'mailer' }
#     end
#   end
# end
class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to BugMe!')
  end
end
