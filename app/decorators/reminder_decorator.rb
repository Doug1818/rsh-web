class ReminderDecorator < Draper::Decorator
  delegate_all

  include Draper::LazyHelpers

  def frequency_output
    case Reminder::FREQUENCIES.keys[frequency]
    when 'Daily'
      "Every #{ pluralize(daily_recurrence, 'day') }"
    when 'Weekly'
      "Every #{ pluralize(weekly_recurrence, 'week') } on #{ Reminder::DAYS_OF_THE_WEEK.keys[day_of_week] }"
    when 'Monthly'
      "Every #{ pluralize(monthly_recurrence, 'month') }"
    else
      Reminder::FREQUENCIES.keys[frequency]
    end
  end
end
