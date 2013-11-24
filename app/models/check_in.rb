class CheckIn < ActiveRecord::Base
  belongs_to :small_step
  has_many :activities
  has_and_belongs_to_many :excuses
end
