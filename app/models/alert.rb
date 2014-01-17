class Alert < ActiveRecord::Base
  # Misses: ?, Incompletes: X, Completes: √ (These should be graphical in the interface)
  ACTION_TYPES = { "Misses" => 0, "Incompletes" => 1, "Completes" => 2 }
  SEQUENCES = { "In a row" => 0, "In a week" => 1 }
  belongs_to :program
  has_one :user, through: :program


  def self.check_alerts
    Program.where(status: Program::STATUSES[:active]).each do |program|
      @alerts = program.alerts
      @alerts.each do |alert|
        puts "PROGRAM: #{program.id}"
        statuses = []

        @check_ins = program.check_ins.order(created_at: :asc).last(alert.streak)
        next if @check_ins.empty? || @check_ins.size != alert.streak

        puts "CHECK INS: #{@check_ins}"
        @check_ins.each do |check_in|
          statuses.push(check_in.status)
        end

        if alert.action_type == ACTION_TYPES["Misses"]
          puts "MISSES..."
        elsif alert.action_type == ACTION_TYPES["Incompletes"]
          streak_met = true
          statuses.each do |status|
            unless status == CheckIn::STATUSES[:mixed] || status == CheckIn::STATUSES[:all_no]
              streak_met = false
              break
            end
          end

          if streak_met
            puts "STREAK MET FOR INCOMPLETES"
          else
            puts "STREAK NOT MET FOR INCOMPLETES"
          end
        elsif alert.action_type == ACTION_TYPES["Completes"]
          if statusus.uniq.size == 1 && (statuses[0] == CheckIn::STATUSES[:all_yes])
            puts "STREAK MET FOR COMPLETES"
          else
            puts "STREAK NOT MET FOR COMPLETES"
          end
        end
      end
    end
  end
end
