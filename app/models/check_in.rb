class CheckIn < ActiveRecord::Base
  belongs_to :small_step
  belongs_to :week
  has_many :activities
  has_and_belongs_to_many :excuses
end
