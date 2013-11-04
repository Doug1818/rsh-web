class Coach < ActiveRecord::Base
  belongs_to :practice

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
