class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.integer :program_id
      t.text :body
      t.integer :frequency
      t.datetime :send_at

      t.timestamps
    end
  end
end
