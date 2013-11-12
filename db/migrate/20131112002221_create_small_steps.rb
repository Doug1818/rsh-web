class CreateSmallSteps < ActiveRecord::Migration
  def change
    create_table :small_steps do |t|
      t.integer :big_step_id
      t.string :name
      t.integer :priority
      t.integer :length
      t.integer :frequency
      t.integer :times_per_week
      t.boolean :sunday
      t.boolean :monday
      t.boolean :tuesday
      t.boolean :wednesday
      t.boolean :thursday
      t.boolean :friday
      t.boolean :saturday

      t.timestamps
    end
  end
end
