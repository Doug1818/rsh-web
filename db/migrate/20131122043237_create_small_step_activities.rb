class CreateSmallStepActivities < ActiveRecord::Migration
  def change
    create_table :small_step_activities do |t|
      t.integer :small_step_id
      t.integer :status
      t.integer :excuse
      t.text :comments

      t.timestamps
    end
  end
end
