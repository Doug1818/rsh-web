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

  def required_on_date(date)

    return false if date.nil?

    start_date = date.beginning_of_week(:sunday)
    end_date = date.end_of_week(:sunday)

    case FREQUENCIES.keys[frequency]
    when "Daily"
      true
    when "Specific Days"
      days.include?(date.strftime('%a')) ? true : false # %a = Mon, Tues, Wed, etc.
    when "Times Per Week"
      check_ins_this_week = check_ins.where("check_ins.created_at BETWEEN DATE(?) AND DATE(?)", start_date, end_date)
      check_ins_this_week.count < times_per_week ? true : false   
    else
      false
    end

  end

  # def needs_check_in_for_date(date)

  #   return false if date.nil?

  #   start_date = date.beginning_of_week(:sunday)
  #   end_date = date.end_of_week(:sunday)

  #   check_ins_today = check_ins.where("check_ins.created_at = DATE(?)", date)

  #   case FREQUENCIES.keys[frequency]
  #   when "Daily"
  #     check_ins_today.count == 0 ? true : false
  #   when "Specific Days"
  #     days.include?(date.strftime('%a')) and check_ins_today.count == 0 ? true : false # %a = Mon, Tues, Wed, etc.
  #   when "Times Per Week"
  #     check_ins_this_week = check_ins.where("check_ins.created_at BETWEEN DATE(?) AND DATE(?)", start_date, end_date)
  #     check_ins_this_week.count < times_per_week and check_ins_today.count == 0 ? true : false   
  #   else
  #     false
  #   end
  # end

  def as_json(options = {})
    json = super(options)
    json['requires_check_in'] = required_on_date(options[:date]) if options[:date]
    json
  end
end


