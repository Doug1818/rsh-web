class AddDefaultToCoachTimezone < ActiveRecord::Migration
  def change
  	change_column :coaches, :timezone, :string, default: "Eastern Time (US & Canada)"
  end
end
