class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer :program_id
      t.integer :action_type
      t.integer :streak
      t.integer :sequence

      t.timestamps
    end
  end
end
