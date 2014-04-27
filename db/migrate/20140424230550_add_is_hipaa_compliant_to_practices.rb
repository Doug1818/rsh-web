class AddIsHipaaCompliantToPractices < ActiveRecord::Migration
  def change
  	add_column :practices, :hipaa_compliant, :boolean, default: false
  end
end
