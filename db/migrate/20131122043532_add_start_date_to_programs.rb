class AddStartDateToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :start_date, :date
  end
end
