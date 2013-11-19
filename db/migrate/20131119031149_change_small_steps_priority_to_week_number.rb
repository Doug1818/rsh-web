class ChangeSmallStepsPriorityToWeekNumber < ActiveRecord::Migration
  def change
    rename_column :small_steps, :priority, :week_number
  end
end
