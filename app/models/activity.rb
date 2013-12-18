class Activity < ActiveRecord::Base
  belongs_to :small_step
  belongs_to :check_in
end
