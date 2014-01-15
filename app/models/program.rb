class Program < ActiveRecord::Base
  STATUSES = { inactive: 0, active: 1 }

  before_save :ensure_authentication_token
  after_create :send_invitation

  belongs_to :user, dependent: :destroy
  belongs_to :coach

  has_many :big_steps, dependent: :destroy
  has_many :small_steps, dependent: :destroy
  has_many :check_ins, through: :small_steps
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

  def current_week
    self.weeks.where("? BETWEEN start_date and end_date", Time.now).first
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  private

  def generate_authentication_token
    if Rails.env.development?
      token = "a"
    else
      loop do
        token = SecureRandom.base64(4).tr('+/=', '0aZ')
        break token unless Program.where(authentication_token: token).first
      end
    end
  end

  def send_invitation
    # TODO remove the unless when we're ready to go live
    UserMailer.user_invitation_email(self).deliver unless Rails.env.production?
  end


  def self.nudge_reminder
    @today = DateTime.new
    Program.where(status: STATUSES[:active]).each do |program|
      @current_week = program.current_week
      if @current_week.present?

        # @current_week.small_steps.each
          # needs_check_in_on_date(@today)
          # if true, send message
        #

        unless @current_week.has_check_in_for_day(@today)
          puts "SEND PUSH"
          data = { :alert => "Don't forget to check in today!" }
          push = Parse::Push.new(data, "user_169")
          push.type = "ios"
          push.save
        end
      end
    end
  end
end
