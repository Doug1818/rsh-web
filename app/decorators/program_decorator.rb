class ProgramDecorator < Draper::Decorator
  delegate_all

  include Draper::LazyHelpers

  def daily_checkmarks
    today = Date.today
    start_date = today.beginning_of_week(:sunday)
    end_date = today.end_of_week(:sunday)

    statuses = (start_date..end_date).collect do |day|
      check_in = program.check_ins.find_by(created_at: day)

      status = if check_in.nil?
        0
      else
        check_in.status
      end
    end

    content_tag(:ul, class: 'list-inline') do 
      statuses.map do |item|
        concat(content_tag(:li, nil, class: "check-in status-#{item}"))
      end
    end
  end

  def day_number(day)
    date_difference = (day - start_date).to_i + 1
    "Day #{date_difference}" if date_difference > 0
  end

end
