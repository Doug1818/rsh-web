class SmallStep < ActiveRecord::Base
  FREQUENCIES = { "Daily" => 0, "# Times Per Week" => 1, "Specific Days of the Week" => 2 }

  belongs_to :program
  belongs_to :big_step
  has_many :small_step_activites, dependent: :destroy
end
