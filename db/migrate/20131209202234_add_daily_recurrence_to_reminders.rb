class AddDailyRecurrenceToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :daily_recurrence, :integer
  end
end
