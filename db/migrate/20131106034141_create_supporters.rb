class CreateSupporters < ActiveRecord::Migration
  def change
    create_table :supporters do |t|
      t.integer :program_id
      t.string :email

      t.timestamps
    end
  end
end
