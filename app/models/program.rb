class Program < ActiveRecord::Base
  STATUSES = { inactive: 0, active: 1 }
  ACTIVITY_STATUSES = { normal: 0, alert: 1 }

  before_save :ensure_authentication_token
  # after_create :send_invitation
  after_create :create_default_alert

  belongs_to :user, dependent: :destroy
  # belongs_to :coach
  has_and_belongs_to_many :coaches

  has_many :big_steps, dependent: :destroy
  has_many :small_steps, dependent: :destroy
  has_many :check_ins, through: :small_steps, uniq: true
  has_many :weeks

  has_many :alerts, dependent: :destroy
  has_many :reminders, dependent: :destroy
  has_many :supporters, dependent: :destroy
  has_many :todos, dependent: :destroy

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :big_steps, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :weeks, :reject_if => :all_blank, :allow_destroy => true

  attr_accessor :new_coach
  
  validates_associated :big_steps
  validates_associated :small_steps
  validates :purpose, presence: true, :on => :create
  validates :goal, presence: true, :on => :create
  # validates :start_date, presence: true, :on => :update

  scope :active, -> { where(status: STATUSES[:active]) }
  scope :alerts, -> { where(activity_status: ACTIVITY_STATUSES[:alert]) }

  searchable do
    integer :id
    text :user do
      user.full_name
    end
    text :purpose
    text :goal
  end

  def total_missed_check_ins
    # get # of days from program.start_date to today
    # get # of checkins
    # subtract the two
  end

  def total_could_have_checked_in_days # taking the whole program's small steps... needs to be just the ones relevant for that week (or day?)
    could_have_checked_in_days = []
    start_date = self.start_date
    end_date = DateTime.now.in_time_zone(self.user.timezone).to_date - 2
    (start_date..end_date).each do |day|
      can_check_in = false
      self.small_steps.each do |small_step|
        if small_step.can_check_in_on_date(day) == true
          can_check_in = true
          break
        end
      end
      could_have_checked_in_days << day if can_check_in == false
    end
    return could_have_checked_in_days
  end

  def misses_streak
    if self.start_date != nil
      now = DateTime.now.in_time_zone(self.user.timezone)
      today = now.to_date
      last_closed_check_in_window = today - 2 # get date of last 'closed' check-in
      no_check_ins_since = if self.check_ins.any?
        self.check_ins.last.created_at.to_date # get the date of the last check-in
      else
        self.start_date
      end
      return (last_closed_check_in_window - no_check_ins_since).to_int # see the difference between them
    end
  end

  def current_week
    self.weeks.where("? BETWEEN start_date and end_date", Time.current).first
  end

  def next_week
    if current_week.present?
      self.weeks.where(number: current_week.number + 1).first
    else
      nil
    end
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  private

  def generate_authentication_token
    loop do
      token = (0...6).map { ('a'..'z').to_a[rand(26)] }.join
      break token unless Program.where(authentication_token: token).first
    end
  end

  def send_invitation
    UserMailer.user_invitation_email(self).deliver
  end

  def create_default_alert
    self.alerts.create(action_type: 0, streak: 3, sequence: 0)
  end

  def self.nudge_reminder
    Program.where(status: STATUSES[:active]).each do |program|
      @now = DateTime.now.in_time_zone(program.user.timezone)
      @today = @now.to_date
      @current_week = program.current_week
      if @current_week.present?

        should_notify = false

        @current_week.small_steps.each do |small_step|
          if small_step.needs_check_in_on_date(@today) == true && small_step.has_check_in_on_date(@today) == false
            should_notify = true
            break
          end
        end

        if should_notify && @now.hour == 21
          data = { :alert => "Don't forget to check in today!" }
          push = Parse::Push.new(data, "user_#{program.user.id}")
          push.type = "ios"
          push.save
        end
      end
    end
  end

  def self.more_steps_reminder
    Program.where(status: STATUSES[:active]).each do |program|
      program.coaches.each do |coach|
        @current_week = program.current_week
        @next_week = program.next_week
        weekday_num = Time.now.in_time_zone(coach.timezone).to_date.wday
        if @current_week.present? && weekday_num == 5
          UserMailer.coach_more_steps_email(program, coach).deliver if @next_week.nil? || @next_week.small_steps.empty?
        end
      end
    end
  end
end
