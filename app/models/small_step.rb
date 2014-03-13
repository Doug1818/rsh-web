class SmallStep < ActiveRecord::Base
  FREQUENCIES = { "Daily" => 0, "Times Per Week" => 1, "Specific Days" => 2 }

  belongs_to :program
  has_and_belongs_to_many :weeks
  belongs_to :big_step
  has_many :activities
  has_many :check_ins, through: :activities, dependent: :destroy
  has_many :attachments, dependent: :destroy
  has_one :note

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

  def humanize_frequency
    FREQUENCIES.keys[frequency]
  end

  # All check ins needed for a day, regardless of whether or not the check in occurred
  def can_check_in_on_date(date)
    begin
      date = Date.parse(date) unless date.is_a? Date # ensure date is a Date object if passed in as a string

      case FREQUENCIES.keys[frequency]
      when "Daily"
        true
      when "Specific Days"
        days.include?(date.strftime('%a')) # %a = Mon, Tues, Wed, etc.
      when "Times Per Week"
        needs_check_in_on_date(date) or has_check_in_on_date(date)
      else
        false
      end
    rescue
      false
    end
  end

  # Check ins for a day that are needed and have not occurred
  def needs_check_in_on_date(date, up_to_date=false)
    begin
      date = Date.parse(date) unless date.is_a? Date # ensure date is a Date object if passed in as a string

      check_ins_on_date = check_ins.where("check_ins.created_at = DATE(?)", date).pluck(:id) # look to see if a check in exists for this day already

      case FREQUENCIES.keys[frequency]
      when "Daily"
        check_ins_on_date.count == 0
      when "Specific Days"
        check_ins_on_date.count == 0 and days.include?(date.strftime('%a')) # %a = Mon, Tues, Wed, etc.
      when "Times Per Week"
        # True if the user hasn't checked in with "Yes" enough times this week
        beginning_of_week = date.beginning_of_week(:sunday)
        end_of_week = up_to_date ? date : date.end_of_week(:sunday)

        check_ins_this_week = check_ins.where("check_ins.created_at BETWEEN DATE(?) AND DATE(?)", beginning_of_week, end_of_week).pluck(:id)

        yes_check_ins_as_of_date = activities.where(check_in_id: check_ins_this_week, status: Activity::STATUSES[:yes]).count
        check_ins_on_date.count == 0 and yes_check_ins_as_of_date < times_per_week
      else
        false
      end
    rescue
      false
    end
  end

  def has_check_in_on_date(date)
    date = Date.parse(date) unless date.is_a? Date # ensure date is a Date object if passed in as a string
    check_in = check_ins.find_by(created_at: date)
    check_in.nil? ? false : true
  end

  def get_note
    note.body if note
  end

  def get_attachments
    attachments.collect { |attachment| {friendly_name: attachment.filename.file.filename, url: attachment.filename.url } }
  end

  def as_json(options = {})
    json = super(options)
    json['specific_days'] = humanize_days
    json['frequency_name'] = humanize_frequency
    json['note'] = get_note
    json['attachments'] = get_attachments
    json
  end
end


