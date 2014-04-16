class AddTvIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tv_id, :string
  end
end
