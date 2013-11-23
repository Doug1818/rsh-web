class CreateCheckIns < ActiveRecord::Migration
  def change
    create_table :check_ins do |t|
      t.integer :small_step_id
      t.text :comments

      t.timestamps
    end
  end
end
