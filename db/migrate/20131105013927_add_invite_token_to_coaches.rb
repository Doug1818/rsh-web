class AddInviteTokenToCoaches < ActiveRecord::Migration
  def change
    add_column :coaches, :invite_token, :string
  end
end
