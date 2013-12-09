class AddWeeklyRecurrenceToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :weekly_recurrence, :integer
  end
end
