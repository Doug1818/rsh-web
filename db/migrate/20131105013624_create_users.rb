class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :invite_token
      t.integer :status
      t.string :device_id
      t.string :gender

      t.timestamps
    end
  end
end
