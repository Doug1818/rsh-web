class CreateCheckInExcuses < ActiveRecord::Migration
  def change
    create_table :check_ins_excuses, id: false do |t|
      t.references :check_in, null: false
      t.references :excuse, null: false
    end
  end
end
