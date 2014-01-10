class Coach < ActiveRecord::Base
  STATUSES = { invited: 0, inactive: 1, active: 2 }
  GENDERS = ['', "Male", "Female"]

  belongs_to :practice
  has_many :programs
  has_many :users, through: :programs

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  before_create :generate_invite_token
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
end
