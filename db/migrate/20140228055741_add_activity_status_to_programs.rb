class AddActivityStatusToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :activity_status, :integer, default: 0
  end
end
