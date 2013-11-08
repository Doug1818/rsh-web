class Alert < ActiveRecord::Base
  ACTION_TYPES = { "Misses" => 0 }
  SEQUENCES = { "In a row" => 0 }
  belongs_to :program
  has_one :user, through: :program
end