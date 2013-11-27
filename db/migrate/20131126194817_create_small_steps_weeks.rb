class CreateSmallStepsWeeks < ActiveRecord::Migration
  def change
    create_table :small_steps_weeks, id: false do |t|
      t.references :small_step, null: false
      t.references :week, null: false
    end
  end
end
