class Program < ActiveRecord::Base
  STATUSES = { inactive: 0, active: 1 }

  before_save :ensure_authentication_token
  after_create :send_invitation

  belongs_to :user, dependent: :destroy
  belongs_to :coach
  has_many :big_steps, dependent: :destroy
  # has_many :small_steps, through: :big_steps, dependent: :destroy
  has_many :small_steps, dependent: :destroy
  has_many :alerts, dependent: :destroy
  has_many :reminders, dependent: :destroy
  has_many :supporters, dependent: :destroy
  has_many :todos, dependent: :destroy

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :big_steps, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :small_steps, :reject_if => :all_blank, :allow_destroy => true

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
    UserMailer.invitation_email(self).deliver
  end
end
