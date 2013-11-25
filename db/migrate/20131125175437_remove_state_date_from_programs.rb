class RemoveStateDateFromPrograms < ActiveRecord::Migration
  def change
    remove_column :programs, :state_date
  end
end
