class Activity < ActiveRecord::Base
  STATUSES = { no: 0, yes: 1 }
  
  belongs_to :small_step
  belongs_to :check_in
end
