class AddDateToAccomplishments < ActiveRecord::Migration
  def change
    add_column :accomplishments, :date, :date
  end
end
