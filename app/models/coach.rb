class Coach < ActiveRecord::Base
  STATUSES = { invited: 0, inactive: 1, active: 2 }
  GENDERS = ["Male", "Female", "I'd rather not say"]

  belongs_to :practice
  has_many :programs
  has_many :users, through: :programs

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, AvatarUploader

  def full_name
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}"
    else
      "Coach"
    end
  end

  def name
    if first_name.present?
      "#{first_name}"
    else
      "Coach"
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
end
