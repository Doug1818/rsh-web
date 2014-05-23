class CreateAccomplishments < ActiveRecord::Migration
  def change
    create_table :accomplishments do |t|
      t.string :name
      t.integer :program_id

      t.timestamps
    end
  end
end
