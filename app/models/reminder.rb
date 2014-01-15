class Reminder < ActiveRecord::Base

  STATUSES = { scheduled: 0, sent: 1 }
  FREQUENCIES = { "Once" => 0, "Daily" => 1, "Weekly" => 2, "Monthly" => 3 }
  DAYS_OF_THE_WEEK = { "Sunday" => 0, "Monday" => 1, "Tuesday" => 2, "Wednesday" => 3, "Thursday" => 4, "Friday" => 5, "Saturday" => 6 }

  belongs_to :program
  has_one :user, through: :program

  before_save :set_send_at


  def should_send_now?
    require 'active_support/time'

    tz = self.user.timezone
    date_time_now = DateTime.now.in_time_zone(tz)
    send_on_date = self.send_on.in_time_zone(tz)
    send_at_time = date_time_now.change(hour: send_at.in_time_zone(tz).hour, minute: send_at.in_time_zone(tz).min)

    if self.frequency == FREQUENCIES["Once"]

      puts "ONE TIME..."
      send_at_time = send_on_date.change(hour: send_at.in_time_zone(tz).hour, minute: send_at.in_time_zone(tz).min)

      if send_on_date.beginning_of_day == date_time_now.beginning_of_day
        if date_time_now >= send_at_time
          puts "SEND IT"
        end
      end
    elsif self.frequency == FREQUENCIES["Daily"]
      puts "DAILY..."
      schedule = IceCube::Schedule.new(now = send_on_date) do |s|
        s.add_recurrence_rule(IceCube::Rule.daily(self.daily_recurrence))
      end
      if schedule.occurs_on?(date_time_now) && (date_time_now >= send_at_time)
        puts "SEND IT..."
      end
    elsif self.frequency == FREQUENCIES["Weekly"]
      puts "WEEKLY..."
      schedule = IceCube::Schedule.new(now = send_on_date) do |s|
        s.add_recurrence_rule(IceCube::Rule.weekly(self.weekly_recurrence).day(send_on_date.wday))
      end
      if schedule.occurs_on?(date_time_now) && (date_time_now >= send_at_time)
        puts "SEND IT..."
      end
    elsif self.frequency == FREQUENCIES["Monthly"]
      puts "MONTHLY..."
      schedule = IceCube::Schedule.new(now = send_on_date) do |s|
        s.add_recurrence_rule(IceCube::Rule.monthly(self.monthly_recurrence).day_of_month(send_on_date.day))
      end
      puts "FIRST THREE: #{schedule.first(3)}"
      if schedule.occurs_on?(date_time_now) && (date_time_now >= send_at_time)
        puts "SEND IT..."
      end
    end
  end

  private

  def set_send_at
    time = Time.parse(send_at.strftime("%H:%M %p"))
    self.send_at = DateTime.parse("#{ send_on } #{ time }")
  end

  def self.scheduled_reminder
    Program.where(status: Program::STATUSES[:active]).each do |program|
      # get scheduled reminders
      @reminders = program.reminders.where(status: STATUSES[:scheduled])

      # loop through each reminder, and determine whether we need to send it now
      @reminders.each do |reminder|
        reminder.should_send_now?
      end
    end
  end

end
