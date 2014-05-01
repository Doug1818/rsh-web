class AddParseIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :parse_id, :string
  end
end
