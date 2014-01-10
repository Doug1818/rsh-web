class UserMailer < ActionMailer::Base
  default from: "no-reply@rightsidehealth.com"

  def user_invitation_email(program)
    @program = program
    @user = program.user

    mail(to: @user.email, subject: "You've been invited to join Right Side Health")
  end

  def coach_invitation_email(coach)
    @coach = coach

    mail(to: @coach.email, subject: "You've been invited to join Right Side Health")
  end

end
