class Program < ActiveRecord::Base
  STATUSES = { inactive: 0, active: 1 }

  before_save :ensure_authentication_token
  after_create :send_invitation

  belongs_to :user, dependent: :destroy
  belongs_to :coach

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

  validates_associated :big_steps
  validates_associated :small_steps
  validates :purpose, presence: true, :on => :create
  validates :goal, presence: true, :on => :create

  scope :active, -> { where(status: STATUSES[:active]) }
  scope :alerts, -> { joins(:alerts) }

  searchable do
    integer :coach_id do
      coach.id
    end
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

  def current_week
    self.weeks.where("? BETWEEN start_date and end_date", Time.current).first
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
    # TODO remove the unless when we're ready to go live
    UserMailer.user_invitation_email(self).deliver
  end

  def self.nudge_reminder
    @today = DateTime.new
    Program.where(status: STATUSES[:active]).each do |program|
      @current_week = program.current_week
      if @current_week.present?

        should_notify = false

        @current_week.small_steps.each do |small_step|
          if small_step.needs_check_in_on_date(@today) == true
            should_notify = true
            break
          end
        end

        if should_notify && Time.now.in_time_zone(program.user.timezone).hour == 21
          data = { :alert => "Don't forget to check in today!" }
          push = Parse::Push.new(data, "user_#{program.user.id}")
          push.type = "ios"
          push.save
        end
      end
    end
  end
end
