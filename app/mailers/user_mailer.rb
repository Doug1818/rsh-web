class UserMailer < ActionMailer::Base
  default from: "Steps <no-reply@rightsidehealth.com>"

  def user_invitation_email(program)
    @program = program
    @user = program.user

    mail(to: @user.email, subject: "You've been invited to join Steps")
  end

  def practice_invitation_email(coach)
    @coach = coach
    @practice = Practice.find(@coach.practice_id)

    mail(to: @coach.email, subject: "You've been invited to join Steps (by Right Side Health)")
  end

  def coach_invitation_email(coach)
    @coach = coach

    mail(to: @coach.email, subject: "You've been invited to join Steps (by Right Side Health)")
  end

  def coach_referral_email(referral)
    @referral = referral
    @coach = Coach.find(@referral.coach_id)
    mail(to: @referral.email, subject: "#{@coach.full_name} thinks you should join Steps (by Right Side Health)")
  end

  def coach_alert_email(alert, streak)
    @alert = alert
    @streak = streak
    @program = Program.find(@alert.program_id)
    @user = @program.user
    @coach = Coach.find(@program.coach_id)
    mail(to: @coach.email, subject: "#{@user.full_name} has gotten #{@streak} #{Alert::ACTION_TYPES.keys[@alert.action_type]} in a row")
  end
end
