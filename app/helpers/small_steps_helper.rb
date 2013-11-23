module SmallStepsHelper
  def display_frequency(small_step)
    if small_step.frequency == SmallStep::FREQUENCIES["Daily"]
      "Daily"
    elsif small_step.frequency == SmallStep::FREQUENCIES["# Times Per Week"]
      "#{pluralize(small_step.times_per_week, 'times')} per week"
    elsif small_step.frequency == SmallStep::FREQUENCIES["Specific Days of the Week"]
      small_step.humanize_days
    else
      "Undefined frequency"
    end
  end
end
