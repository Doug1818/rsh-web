class AddFreePassFlagToPractices < ActiveRecord::Migration
  def change
    add_column :practices, :free_pass_flag, :boolean, default: false
  end
end
