class Coach < ActiveRecord::Base
  STATUSES = { invited: 0, inactive: 1, active: 2 }
  GENDERS = ['', "Male", "Female"]

  belongs_to :practice
  # has_many :programs
  has_and_belongs_to_many :programs
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

  def add_example_client
    puts "ADD JOE EXAMPLE"

    program = {
      purpose: "Heal my hip",
      goal: "Play soccer again",
      status: 1,
      start_date: 3.weeks.ago.beginning_of_week(:sunday)
    }
    @program = Program.new(program)

    user = {
      first_name: "Joe",
      last_name: "Example",
      email: Faker::Internet.email,
      phone: "5555555555",
      timezone: "Eastern Time (US & Canada)",
      status: 1,
      gender: "Female",
      avatar: nil
    }
    @user = @program.build_user(user)

    @program.save!
    self.programs << @program

    start_date = @program.start_date.in_time_zone("Eastern Time (US & Canada)").beginning_of_week(:sunday)
    end_date = @program.start_date.in_time_zone("Eastern Time (US & Canada)").end_of_week(:sunday)
    
    0.upto(4) { |i| @program.weeks.create(start_date: start_date + i.week, end_date: end_date + i.week, number: 1 + i) }
    
    big_step_names = ['This is a big step', 'Make better food choices', 'Sleep more and better', 'Cook more', 'Strength', 'Cardio']
    big_step_names.each { |bs_name| @program.big_steps.create(name: bs_name)}

    coffee_small_step = @program.big_steps.find_by_name('Sleep more and better').small_steps.create(
      name: "Drink 2 or fewer cups of coffee per day", frequency: 0, times_per_week: 1)
    @program.big_steps.find_by_name('Sleep more and better').small_steps << coffee_small_step
    @program.small_steps << coffee_small_step
    @program.weeks.first(2).each { |w| w.small_steps << coffee_small_step }

    groceries_small_step = @program.big_steps.find_by_name('Cook more').small_steps.create(
      name: "go grocery shopping", frequency: 2, times_per_week: 1, sunday: true)
    @program.big_steps.find_by_name('Cook more').small_steps << groceries_small_step
    @program.small_steps << groceries_small_step
    @program.weeks.first(2).each { |w| w.small_steps << groceries_small_step }

    example_small_step = @program.big_steps.find_by_name('This is a big step').small_steps.create(
      name: "This is a small step (hover/click the edit button to change me)", frequency: 0)
    @program.big_steps.find_by_name('This is a big step').small_steps << example_small_step
    @program.small_steps << example_small_step
    @program.weeks.last(2).each { |w| w.small_steps << example_small_step }

    lowcarb_small_step = @program.big_steps.find_by_name('Make better food choices').small_steps.create(
      name: "Strict Slow-Carb", frequency: 1, times_per_week: 6)
    @program.big_steps.find_by_name('Make better food choices').small_steps << lowcarb_small_step
    @program.small_steps << lowcarb_small_step
    @program.weeks.last(3).each { |w| w.small_steps << lowcarb_small_step }

    workoutA_small_step = @program.big_steps.find_by_name('Strength').small_steps.create(
      name: "Total Body A", frequency: 2, times_per_week: 1, tuesday: true, thursday: true)
    note = Note.create(body: "Warm- Up\r\nRoll- Foam Calves, Quads, Hip\r\nTreadmill- 5 mins 2inc/5-7mph\r\nInchworm, Side Squats, Wall Slides, Knee Pulls\r\nPractice Diaph Breathing\r\n\r\nBridges- 15x\r\nHigh Plank- 1:00\r\n3 sets\r\n\r\nSquats- 12k KB 10x\r\nTRX Rows- 10x\r\n3x\r\n\r\nFront Lunges- Body Weight 10/side (down and back in the lane)\r\nPush ups- low bench- 10x\r\n3x")
    workoutA_small_step.note = note
    @program.big_steps.find_by_name('Strength').small_steps << workoutA_small_step
    @program.small_steps << workoutA_small_step
    @program.weeks.last(3).each { |w| w.small_steps << workoutA_small_step }

    workoutB_small_step = @program.big_steps.find_by_name('Strength').small_steps.create(
      name: "Total Body B", frequency: 2, times_per_week: 1, wednesday: true, saturday: true)
    note = Note.create(body: "Front Lunges 10x/side (hands behind your head)\r\nBicycles 30x/side\r\nHigh Push-ups 10x\r\nRepeat 3x")
    workoutB_small_step.note = note
    @program.big_steps.find_by_name('Strength').small_steps << workoutA_small_step
    @program.small_steps << workoutB_small_step
    @program.weeks.last(3).each { |w| w.small_steps << workoutB_small_step }

    @program.seed_checkins
    @program.alerts.first.update_attributes(streak: 20)
  end

  def check_alerts
    self.programs.each do |program|
      program.alerts.each do |alert|
        puts "PROGRAM: #{program.id}"

        if alert.action_type == Alert::ACTION_TYPES["Misses"]
          puts "MISSES..."
          next if program.start_date.nil?

          now = DateTime.now.in_time_zone(program.user.timezone)
          today = now.to_date
          last_closed_check_in_window = today - 2 # get date of last 'closed' check-in
          no_check_ins_since = if program.check_ins.any?
            program.check_ins.last.created_at.to_date # get the date of the last check-in
          else
            program.start_date
          end
          misses_streak = last_closed_check_in_window - no_check_ins_since # see the difference between them
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
          statuses = []

          @check_ins = program.check_ins.order(created_at: :asc).last(alert.streak)
          next if @check_ins.empty? || @check_ins.size != alert.streak

          puts "CHECK INS: #{@check_ins}"
          @check_ins.each do |check_in|
            statuses.push(check_in.status)
          end

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
