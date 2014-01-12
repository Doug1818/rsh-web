class AddRefferedByCodeToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :referred_by_code, :string
  end
end
