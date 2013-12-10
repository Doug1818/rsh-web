class AddSendOnToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :send_on, :date
  end
end
