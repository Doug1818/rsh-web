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

    begin
      date = Date.parse(date) unless date.is_a? Date # ensure date is a Date object if passed in as a string

      case FREQUENCIES.keys[frequency]
      when "Daily"
        true
      when "Specific Days"
        days.include?(date.strftime('%a')) # %a = Mon, Tues, Wed, etc.
      when "Times Per Week"
        # True if, as of the given date, the user hasn't checked in enough times.
        beginning_of_week = date.beginning_of_week(:sunday)
        check_ins_this_week = check_ins.where("check_ins.created_at BETWEEN DATE(?) AND DATE(?)", beginning_of_week, date)
        
        check_ins_this_week.count < times_per_week ? true : false   
      else
        false
      end
    rescue
      false
    end
  end

  def as_json(options = {})
    json = super(options)
    json['requires_check_in'] = required_on_date(options[:date]) if options[:date]
    json
  end
end


