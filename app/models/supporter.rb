class Supporter < ActiveRecord::Base
  belongs_to :program
  has_one :user, through: :program
end
