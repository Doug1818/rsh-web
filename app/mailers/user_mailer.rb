class UserMailer < ActionMailer::Base
  default from: "no-reply@rightsidehealth.com"

  def invitation_email(program)
    @program = program
    @user = program.user

    mail(to: @user.email, subject: "You've been invited to join Right Side Health")
  end

end
