class AddIsHipaaCompliantToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hipaa_compliant, :boolean, default: false
  end
end
