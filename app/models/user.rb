class User < ActiveRecord::Base
  STATUSES = { invited: 0, inactive: 1, active: 2 }

  has_many :programs
  has_many :coaches, through: :programs

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
