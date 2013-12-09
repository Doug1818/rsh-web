class Reminder < ActiveRecord::Base
  FREQUENCIES = { "Once" => 0, "Daily" => 1, "Weekly" => 2, "Monthly" => 3 }
  DAYS_OF_THE_WEEK = { "Sunday" => 0, "Monday" => 1, "Tuesday" => 2, "Wednesday" => 3, "Thursday" => 4, "Friday" => 5, "Saturday" => 6 }

  belongs_to :program
  has_one :user, through: :program

  before_save :set_send_at

  private

  # Use the provided time if it's specified,
  # otherwise set it to 8:00 AM.
  def set_send_at
    time = unless send_at.nil?
      Time.parse(send_at.strftime("%H:%M %p")) 
    else
      Time.parse("8:00 AM")
    end
    self.send_at = DateTime.parse("#{ send_on } #{ time }")
  end
end
