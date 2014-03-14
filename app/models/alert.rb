class Alert < ActiveRecord::Base
  # Misses: ?, Incompletes: X, Completes: √ (These should be graphical in the interface)
  ACTION_TYPES = { "Misses" => 0, "Incompletes" => 1, "Completes" => 2 }
  # SEQUENCES = { "In a row" => 0, "In a week" => 1 }
  SEQUENCES = { "In a row" => 0 }
  belongs_to :program
  has_one :user, through: :program


  def self.check_alerts
    Program.where(status: Program::STATUSES[:active]).each do |program|
      now = DateTime.now.in_time_zone(program.user.timezone)
      if now.hour == 0 # check alerts at midnight local user time
        @alerts = program.alerts
        @alerts.each do |alert|
          puts "PROGRAM: #{program.id}"

          if alert.action_type == ACTION_TYPES["Misses"]
            puts "MISSES..."
            next if program.start_date.nil?

            today = now.to_date
            last_closed_check_in_window = today - 2 # get date of last 'closed' check-in
            no_check_ins_since = if program.check_ins.any?
              program.check_ins.last.created_at.to_date # get the date of the last check-in
            else
              program.start_date
            end
            misses_streak = last_closed_check_in_window - no_check_ins_since # see the difference between them
            misses_streak >= alert.streak ? streak_met = true : streak_met = false

            if streak_met
              UserMailer.coach_alert_email(alert, misses_streak.to_int).deliver
              program.activity_status = Program::ACTIVITY_STATUSES[:alert]
              puts "STREAK MET FOR MISSES"
            else
              program.activity_status = Program::ACTIVITY_STATUSES[:normal]
              puts "STREAK NOT MET FOR MISSES"
            end

          elsif alert.action_type == ACTION_TYPES["Incompletes"]
            statuses = []

            @check_ins = program.check_ins.order(created_at: :asc).last(alert.streak)
            next if @check_ins.empty? || @check_ins.size != alert.streak

            puts "CHECK INS: #{@check_ins}"
            @check_ins.each do |check_in|
              statuses.push(check_in.status)
            end

            streak_met = true

            statuses.each do |status|
              if status != CheckIn::STATUSES[:mixed] || status != CheckIn::STATUSES[:all_no]
                streak_met = false

                break
              end
            end

            if streak_met
              UserMailer.coach_alert_email(alert, alert.streak).deliver
              program.activity_status = Program::ACTIVITY_STATUSES[:alert]
              puts "STREAK MET FOR INCOMPLETES"
            else
              program.activity_status = Program::ACTIVITY_STATUSES[:normal]
              puts "STREAK NOT MET FOR INCOMPLETES"
            end

          elsif alert.action_type == ACTION_TYPES["Completes"]
            next if statuses.nil?
            if statuses.uniq.size == 1 && (statuses[0] == CheckIn::STATUSES[:all_yes])
              UserMailer.coach_alert_email(alert, alert.streak).deliver
              puts "STREAK MET FOR COMPLETES"
            else
              puts "STREAK NOT MET FOR COMPLETES"
            end
          end
          program.save
        end
      end
    end
  end
end
