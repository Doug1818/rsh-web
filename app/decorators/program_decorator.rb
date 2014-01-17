class ProgramDecorator < Draper::Decorator
  delegate_all

  include Draper::LazyHelpers

  def daily_checkmarks
    today = Date.today
    
    # Gets last Sunday to next Sunday
    #start_date = today.beginning_of_week(:sunday)
    #end_date = today.end_of_week(:sunday)

    # Gets the last 7 days of closed (48 hour window) checkin data
    end_date = today - 2
    start_date = end_date - 6

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
    if day >= start_date
      date_difference = (day - start_date).to_i + 1
      "Day #{date_difference}" if date_difference > 0
    else
      ""
    end
  end

end
