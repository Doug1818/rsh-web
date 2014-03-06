class Coach < ActiveRecord::Base
  STATUSES = { invited: 0, inactive: 1, active: 2 }
  GENDERS = ['', "Male", "Female"]

  belongs_to :practice
  has_many :programs
  has_many :users, through: :programs
  has_many :referrals

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  before_create :generate_invite_token
  before_create :generate_referral_code
  after_create :invitation_email


  def full_name=(full_name)
    if full_name.present?
      (self.first_name, self.last_name) = full_name.split(" ")
    end
  end

  def full_name
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}"
    else
      name
    end
  end

  def name
    if first_name.present?
      "#{first_name}"
    end
  end

  def password_required?
    # new coaches are created by admin invites. They do not need passwords at that point.
    if new_record?
      false
    else
      (self.password_confirmation.present? || (self.status == 'invited')) ? super : false
    end
  end

  def invitation_email
    if self.role == 'coach'
      UserMailer.coach_invitation_email(self).deliver
    end
  end

  def generate_invite_token
    self.invite_token = SecureRandom.urlsafe_base64
  end

  def generate_referral_code
    self.referral_code = SecureRandom.urlsafe_base64
  end

  def check_alerts
    self.programs.each do |program|
      program.alerts.each do |alert|
        puts "PROGRAM: #{program.id}"
        statuses = []

        @check_ins = program.check_ins.order(created_at: :asc).last(alert.streak)
        next if @check_ins.empty? || @check_ins.size != alert.streak

        puts "CHECK INS: #{@check_ins}"
        @check_ins.each do |check_in|
          statuses.push(check_in.status)
        end

        if alert.action_type == Alert::ACTION_TYPES["Misses"]
          puts "MISSES..."

          now = DateTime.now.in_time_zone(program.user.timezone)
          today = now.to_date
          last_closed_check_in = today - 2 # get date of last 'closed' check-in
          last_check_in_date = program.check_ins.last.created_at.to_date # get the date of the last check-in
          misses_streak = last_closed_check_in - last_check_in_date # see the difference between them
          misses_streak >= alert.streak ? streak_met = true : streak_met = false

          if streak_met
            # UserMailer.coach_alert_email(alert, misses_streak).deliver
            program.activity_status = Program::ACTIVITY_STATUSES[:alert]
            puts "STREAK MET FOR MISSES"
          else
            program.activity_status = Program::ACTIVITY_STATUSES[:normal]
            puts "STREAK NOT MET FOR MISSES"
          end

        elsif alert.action_type == Alert::ACTION_TYPES["Incompletes"]
          streak_met = true

          statuses.each do |status|
            if status != CheckIn::STATUSES[:mixed] || status != CheckIn::STATUSES[:all_no]
              streak_met = false

              break
            end
          end

          if streak_met
            # UserMailer.coach_alert_email(alert, alert.streak).deliver
            program.activity_status = Program::ACTIVITY_STATUSES[:alert]
            puts "STREAK MET FOR INCOMPLETES"
          else
            program.activity_status = Program::ACTIVITY_STATUSES[:normal]
            puts "STREAK NOT MET FOR INCOMPLETES"
          end
        end
        program.save
      end
    end
  end
end
