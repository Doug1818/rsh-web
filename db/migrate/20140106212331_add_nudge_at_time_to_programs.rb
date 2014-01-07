class AddNudgeAtTimeToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :nudge_at_time, :datetime, default: DateTime.new.change({:hour => 20})
  end
end
