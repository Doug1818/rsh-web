class AddDayOfWeekToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :day_of_week, :integer
  end
end
