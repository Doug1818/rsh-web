class CreateBigSteps < ActiveRecord::Migration
  def change
    create_table :big_steps do |t|
      t.integer :program_id
      t.string :name

      t.timestamps
    end
  end
end
