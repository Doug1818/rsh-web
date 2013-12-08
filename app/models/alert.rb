class Alert < ActiveRecord::Base
  # Misses: ?, Incompletes: X, Completes: √ (These should be graphical in the interface)
  ACTION_TYPES = { "Misses" => 0, "Incompletes" => 1, "Completes" => 2 }
  SEQUENCES = { "In a row" => 0, "In a week" => 1 }
  belongs_to :program
  has_one :user, through: :program
end
