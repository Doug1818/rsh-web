class CreateWeeks < ActiveRecord::Migration
  def change
    create_table :weeks do |t|
      t.integer :program_id
      t.date :start_date
      t.date :end_date
      t.integer :number

      t.timestamps
    end
  end
end
