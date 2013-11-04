class AddRoleToCoaches < ActiveRecord::Migration
  def change
    add_column :coaches, :role, :string
  end
end
