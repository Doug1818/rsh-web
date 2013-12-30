class SmallStep < ActiveRecord::Base
  FREQUENCIES = { "Daily" => 0, "Times Per Week" => 1, "Specific Days" => 2 }

  belongs_to :program
  has_and_belongs_to_many :weeks
  belongs_to :big_step
  has_many :activities
  has_many :check_ins, through: :activities, dependent: :destroy

  validates :name, length: { maximum: 100 }, presence: true


  def days
    days = []
    days.push("Sun") if sunday
    days.push("Mon") if monday
    days.push("Tue") if tuesday
    days.push("Wed") if wednesday
    days.push("Thu") if thursday
    days.push("Fri") if friday
    days.push("Sat") if saturday
    days
  end

  def humanize_days
    days.to_sentence
  end

  def needs_check_in(date=nil)
    case FREQUENCIES.keys[frequency]
    when "Daily"
      true
    when "Specific Days"
      unless date.nil?
        days.include?(date.strftime('%a')) ? true : false # %a = Mon, Tues, Wed, etc.
      else
        false
      end
    when "Times Per Week"
      unless date.nil?
        start_date = date.beginning_of_week(:sunday)
        end_date = date.end_of_week(:sunday)
        check_in_count = check_ins.where("check_ins.created_at BETWEEN DATE(?) AND DATE(?)", start_date, end_date).count
        check_in_count < times_per_week ? true : false   
      end
    else
      false
    end
  end
end


