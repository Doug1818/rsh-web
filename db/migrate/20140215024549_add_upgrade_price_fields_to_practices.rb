class AddUpgradePriceFieldsToPractices < ActiveRecord::Migration
  def change
    add_column :practices, :upgrade_price, :integer
    add_column :practices, :upgrade_price_set_at, :datetime
  end
end
