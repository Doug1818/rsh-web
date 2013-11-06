class User < ActiveRecord::Base
  STATUSES = { invited: 0, inactive: 1, active: 2 }

  has_many :programs
  has_many :coaches, through: :programs

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_reader :full_name

  def password_required?
    if new_record?
      false
    else
      (self.password_confirmation.present? || (self.status == 'invited')) ? super : false
    end
  end

  def display_name
    "#{first_name} #{last_name}"
  end

  def full_name=(full_name)
    if full_name.present?
      (self.first_name, self.last_name) = full_name.split(" ")
    end
  end
end
