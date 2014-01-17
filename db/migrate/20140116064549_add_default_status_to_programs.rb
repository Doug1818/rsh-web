class AddDefaultStatusToPrograms < ActiveRecord::Migration
  def change
    change_column :programs, :status, :integer, default: 1
  end
end
