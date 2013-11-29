class AddWeekIdToCheckIns < ActiveRecord::Migration
  def change
    add_column :check_ins, :week_id, :integer
  end
end
