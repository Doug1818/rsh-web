class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :check_in_id
      t.integer :small_step_id
      t.integer :status

      t.timestamps
    end
  end
end
