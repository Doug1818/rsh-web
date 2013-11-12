class BigStep < ActiveRecord::Base
  belongs_to :program
  has_many :small_steps
end
