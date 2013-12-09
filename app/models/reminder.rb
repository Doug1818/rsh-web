class Reminder < ActiveRecord::Base
  FREQUENCIES = { "Once" => 0, "Daily" => 1, "Weekly" => 2, "Monthly" => 3 }
  DAYS_OF_THE_WEEK = { "Sunday" => 0, "Monday" => 1, "Tuesday" => 2, "Wednesday" => 3, "Thursday" => 4, "Friday" => 5, "Saturday" => 6 }

  belongs_to :program
  has_one :user, through: :program

  attr_accessor :send_on

  before_save :set_send_at

  private

  # Time and Date are separate fields in the form
  # This combines them to set the send_at column
  # Note: send_on is a virtual attribute
  def set_send_at
    if self.frequency == FREQUENCIES["Once"]
      time = Time.parse(send_at.strftime("%H:%M %p")) 
      date = Date.parse(send_on)
      self.send_at = DateTime.parse("#{ date.strftime } #{ time }")
    end
  end
end
