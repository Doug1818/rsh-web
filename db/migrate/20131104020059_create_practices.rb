class CreatePractices < ActiveRecord::Migration
  def change
    create_table :practices do |t|
      t.string :name
      t.string :address
      t.string :state
      t.string :city
      t.string :zip
      t.integer :status
      t.string :stripe_customer_id
      t.string :stripe_card_type
      t.string :stripe_card_last4

      t.timestamps
    end
  end
end
