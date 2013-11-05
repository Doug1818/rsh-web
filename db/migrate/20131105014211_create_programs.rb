class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.integer :coach_id
      t.integer :user_id
      t.datetime :state_date
      t.text :purpose
      t.text :goal
      t.integer :status

      t.timestamps
    end
  end
end
