class AddTimezoneToCoaches < ActiveRecord::Migration
  def change
    add_column :coaches, :timezone, :string
  end
end
