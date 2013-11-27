class RemoveWeekNumberAndDaysFromSmallSteps < ActiveRecord::Migration
  def change
    remove_column :small_steps, :week_number
    remove_column :small_steps, :days
  end
end
