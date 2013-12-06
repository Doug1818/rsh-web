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

  scope :active, -> { where(status: STATUSES[:active])}
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

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  private

  def generate_authentication_token
    loop do
      token = SecureRandom.base64(4).tr('+/=', '0aZ')
      break token unless Program.where(authentication_token: token).first
    end
  end

  def send_invitation
    # TODO remove the unless when we're ready to go live
    UserMailer.invitation_email(self).deliver unless Rails.env.production?
  end
end
