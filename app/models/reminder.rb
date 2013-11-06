class Reminder < ActiveRecord::Base
  FREQUENCIES = { "Once" => 0, "Daily" => 1, "Weekly" => 2, "Monthly" => 3 }

  belongs_to :program
  has_one :user, through: :program
end
