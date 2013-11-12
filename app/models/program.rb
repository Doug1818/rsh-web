class Program < ActiveRecord::Base
  STATUSES = { inactive: 0, active: 1 }

  before_create :create_invite_token
  after_create :send_invitation

  belongs_to :user, dependent: :destroy
  belongs_to :coach
  has_many :big_steps, dependent: :destroy
  has_many :small_steps, through: :big_steps, dependent: :destroy
  has_many :alerts, dependent: :destroy
  has_many :reminders, dependent: :destroy
  has_many :supporters, dependent: :destroy
  has_many :todos, dependent: :destroy

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :big_steps, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :small_steps, :reject_if => :all_blank, :allow_destroy => true


  def create_invite_token
    self.invite_token = Security.generate_token
  end

  def send_invitation
    UserMailer.invitation_email(self).deliver
  end
end
