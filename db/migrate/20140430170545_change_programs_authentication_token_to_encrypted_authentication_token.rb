class ChangeProgramsAuthenticationTokenToEncryptedAuthenticationToken < ActiveRecord::Migration
  def up    
    add_column :programs, :encrypted_authentication_token, :string
  
    # encrypt current authentication_tokens
    Program.all.each do |program|
      program.authentication_token = program.read_attribute('authentication_token')
      program.save
    end
    
    remove_column :programs, :authentication_token
      
  end
  
  def down
    # change authentication_tokens back to unencrypted
    # be sure to remove attr_encrypted :authentication_token in program.rb
    Program.all.each { |program| program.update_attributes({encrypted_authentication_token: program.authentication_token}) } 
    
    rename_column :programs, :encrypted_authentication_token, :authentication_token  
  end
end
