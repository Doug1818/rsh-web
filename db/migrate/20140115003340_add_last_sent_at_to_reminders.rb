class AddLastSentAtToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :last_sent_at, :datetime
  end
end
