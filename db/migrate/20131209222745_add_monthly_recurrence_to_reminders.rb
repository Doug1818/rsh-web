class AddMonthlyRecurrenceToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :monthly_recurrence, :integer
  end
end
