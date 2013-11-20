class RenameProgramsInviteTokenToAuthenticationToken < ActiveRecord::Migration
  def change
    rename_column :programs, :invite_token, :authentication_token
  end
end
