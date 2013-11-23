class SmallStep < ActiveRecord::Base
  FREQUENCIES = { "Daily" => 0, "# Times Per Week" => 1, "Specific Days of the Week" => 2 }

  belongs_to :program
  belongs_to :big_step
  has_many :check_ins, dependent: :destroy
  has_many :activities, through: :check_ins

  def humanize_days
    days = []
    days.push("Sun") if sunday
    days.push("Mon") if monday
    days.push("Tue") if tuesday
    days.push("Wed") if wednesday
    days.push("Thu") if thursday
    days.push("Fri") if friday
    days.push("Sat") if saturday

    days.to_sentence
  end
end
