class AddStatusToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :status, :integer, default: 0
  end
end
