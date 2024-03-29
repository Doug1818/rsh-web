class Reminder < ActiveRecord::Base

  STATUSES = { scheduled: 0, sent: 1 }
  FREQUENCIES = { "Once" => 0, "Daily" => 1, "Weekly" => 2, "Monthly" => 3 }
  DAYS_OF_THE_WEEK = { "Sunday" => 0, "Monday" => 1, "Tuesday" => 2, "Wednesday" => 3, "Thursday" => 4, "Friday" => 5, "Saturday" => 6 }

  belongs_to :program
  has_one :user, through: :program

  before_save :set_send_at

  validates :send_at, presence: true
  validates :send_on, presence: true
  validates :body, presence: true
  validate  :presence_of_recurrence


  def should_send_now?
    require 'active_support/time'

    tz = self.user.timezone
    date_time_now = DateTime.now.in_time_zone(tz)
    send_on_date = self.send_on.in_time_zone(tz)
    # send_at_time = date_time_now.change(hour: send_at.in_time_zone(tz).hour, min: send_at.in_time_zone(tz).min)
    send_at_time = date_time_now.change(hour: send_at.hour, min: send_at.min)
    expire_time = 10.minutes # expire time now acts as a buffer (old code: expire_time = send_at_time + 5.minutes)
    send("check_frequency_#{FREQUENCIES.keys[self.frequency].downcase}", tz, date_time_now, send_on_date, send_at_time, expire_time)
  end

  private

  def presence_of_recurrence
    if daily_recurrence == nil && weekly_recurrence == nil && monthly_recurrence == nil
      errors.add(:base, "Frequency can't be blank")
    end unless frequency == 0
  end

  def set_send_at
    time = Time.zone.parse(send_at.strftime("%H:%M %p"))
    self.send_at = DateTime.parse("#{ send_on } #{ time }")
  end


  def check_frequency_once(tz, date_time_now, send_on_date, send_at_time, expire_time)
    puts "CHECKING FREQ ONCE"
    # send_at_time = send_on_date.change(hour: send_at.in_time_zone(tz).hour, min: send_at.in_time_zone(tz).min)
    send_reminder if (send_on_date.to_date == date_time_now.to_date) && time_between?(date_time_now, send_at_time, expire_time)
  end

  def check_frequency_daily(tz, date_time_now, send_on_date, send_at_time, expire_time)
    puts "CHECKING FREQ DAILY"
    schedule = IceCube::Schedule.new(now = send_on_date) do |s|
      s.add_recurrence_rule(IceCube::Rule.daily(self.daily_recurrence))
    end
    send_reminder if schedule.occurs_on?(date_time_now) && time_between?(date_time_now, send_at_time, expire_time)
  end

  def check_frequency_weekly(tz, date_time_now, send_on_date, send_at_time, expire_time)
    puts "CHECKING FREQ WEEKLY"
    schedule = IceCube::Schedule.new(now = send_on_date) do |s|
      s.add_recurrence_rule(IceCube::Rule.weekly(self.weekly_recurrence).day(send_on_date.wday))
    end
    send_reminder if schedule.occurs_on?(date_time_now) && time_between?(date_time_now, send_at_time, expire_time)
  end

  def check_frequency_monthly(tz, date_time_now, send_on_date, send_at_time, expire_time)
    puts "CHECKING FREQ MONTHLY"
    schedule = IceCube::Schedule.new(now = send_on_date) do |s|
      s.add_recurrence_rule(IceCube::Rule.monthly(self.monthly_recurrence).day_of_month(send_on_date.day))
    end
    send_reminder if schedule.occurs_on?(date_time_now) && time_between?(date_time_now, send_at_time, expire_time)
  end

  def time_between?(date_time_now, send_at_time, expire_time)
    # (date_time_now >= send_at_time && date_time_now <= expire_time) # old code
    date_time_now >= (send_at_time - expire_time) && date_time_now <= (send_at_time + expire_time)
  end

  def send_reminder
      data = { alert: self.body }
      push = Parse::Push.new(data, "user_#{self.user.id}")
      push.type = "ios"
      push.save

      self.last_sent_at = DateTime.now.in_time_zone(self.user.timezone)
      self.save
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
