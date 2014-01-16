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
        @check_ins = program.check_ins.last(alert.streak)
        puts "CHECK_INS: #{@check_ins.inspect}"
      end
    end
  end
end
