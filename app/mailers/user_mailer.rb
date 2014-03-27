class UserMailer < ActionMailer::Base
  default from: "Steps <no-reply@rightsidehealth.com>"

  def user_invitation_email(program)
    @program = program
    @user = program.user

    mail(to: @user.email, bcc: "contact@rightsidehealth.com", subject: "#{@program.coach.full_name} has invited you to join Steps")
  end

  def practice_invitation_email(coach)
    @coach = coach
    @practice = Practice.find(@coach.practice_id)

    mail(to: @coach.email, subject: "You've been invited to join Steps (by Right Side Health)")
  end

  def coach_invitation_email(coach)
    @coach = coach

    mail(to: @coach.email, bcc: "contact@rightsidehealth.com", subject: "#{@coach.full_name} has invited you to join Steps (by Right Side Health)")
  end

  def coach_referral_email(referral)
    @referral = referral
    @coach = Coach.find(@referral.coach_id)
    mail(to: @referral.email, bcc: "contact@rightsidehealth.com", subject: "#{@coach.full_name} thinks you should join Steps (by Right Side Health)")
  end

  def coach_alert_email(alert, streak)
    @alert = alert
    @streak = streak
    @program = Program.find(@alert.program_id)
    @user = @program.user
    @coach = Coach.find(@program.coach_id)
    
    mail(to: @coach.email, bcc: "contact@rightsidehealth.com", subject: "#{@user.full_name} has gotten #{@streak} #{Alert::ACTION_TYPES.keys[@alert.action_type]} in a row")
  end

  def coach_more_steps_email(program)
    @program = program
    @user = program.user
    @coach = Coach.find(@program.coach_id)
    
    mail(to: @coach.email, bcc: "contact@rightsidehealth.com", subject: "#{@user.full_name} needs steps for next week")
  end

  def coach_shared_client_email(program, new_coach, referring_coach)
    @program = program
    @user = program.user
    @new_coach = new_coach
    @referring_coach = referring_coach

    mail(to: @new_coach.email, bcc: "contact@rightsidehealth.com", subject: "#{@referring_coach.full_name} has shared #{@user.full_name}'s program with you")
  end
end
