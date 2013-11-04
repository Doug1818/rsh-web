class CreateCoaches < ActiveRecord::Migration
  def change
    create_table :coaches do |t|
      t.integer :practice_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :gender
      t.string :avatar
      t.integer :status

      t.timestamps
    end
  end
end
