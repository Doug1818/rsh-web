class AddInviteTokenToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :invite_token, :string
  end
end
