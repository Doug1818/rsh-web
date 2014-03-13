class Week < ActiveRecord::Base
  belongs_to :program
  has_and_belongs_to_many :small_steps
  has_many :check_ins

  accepts_nested_attributes_for :small_steps, :reject_if => :all_blank, :allow_destroy => true

  def has_check_in_for_day(day)
    if within_week?(day) and check_ins.pluck(:created_at).map(&:wday).include?(day.wday)
      true
    else
      false
    end
  end

  def find_check_in_for_day(day)
    if within_week?(day)
      check_ins.each do |check_in|
        if check_in.created_at.wday == day.wday
          return check_in
        end
      end
    end
  end

  def can_check_in_on_day(day)
    if within_week?(day)
      can_check_in = false
      small_steps.each do |small_step|
        if small_step.can_check_in_on_date(day) == true
          can_check_in = true
          break
        end
      end
      can_check_in
    end
  end

  # ensure the given day is within the current week's range
  def within_week?(day)
    (start_date..end_date).cover?(day)
  end

  def current_week?
    (start_date..end_date).cover? Date.current
  end

  def past_week?
    Date.current > end_date
  end

  def future_week?
    Date.current < start_date
  end

end
