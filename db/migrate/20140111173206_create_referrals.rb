class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.integer :coach_id
      t.string :email

      t.timestamps
    end
  end
end
