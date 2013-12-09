class Week < ActiveRecord::Base
  belongs_to :program
  has_and_belongs_to_many :small_steps
  has_many :check_ins

  accepts_nested_attributes_for :small_steps, :reject_if => :all_blank, :allow_destroy => true

  def has_check_in_for_day(day)
    if check_ins.pluck(:created_at).map(&:wday).include?(day.wday)
      true
    else
      false
    end
  end

  def find_check_in_for_day(day)
    check_ins.each do |check_in|
      if check_in.created_at.wday == day.wday
        return check_in
      end
    end
  end

  def current_week?
    (start_date..end_date).cover? Date.today
  end

  def past_week?
    Date.today > end_date
  end

  def future_week?
    Date.today < start_date
  end

end
