class SmallStep < ActiveRecord::Base
  FREQUENCIES = { "Daily" => 0, "Times Per Week" => 1, "Specific Days" => 2 }

  belongs_to :program
  has_and_belongs_to_many :weeks
  belongs_to :big_step
  has_many :activities
  has_many :check_ins, through: :activities, dependent: :destroy

  validates :name, length: { maximum: 100 }, presence: true

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
