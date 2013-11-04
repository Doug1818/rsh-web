class Coach < ActiveRecord::Base
  GENDERS = ["male", "female", "rather not say"]
  STATUSES = { inactive: 0, active: 1 }
  belongs_to :practice

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  def full_name
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}"
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
