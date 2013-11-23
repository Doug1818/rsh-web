class CreateExcuses < ActiveRecord::Migration
  def change
    create_table :excuses do |t|
      t.integer :practice_id
      t.string :name

      t.timestamps
    end
  end
end
