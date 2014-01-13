class AddReferralCodesToCoaches < ActiveRecord::Migration
  def change
    add_column :coaches, :referral_code, :string
    add_column :coaches, :referred_by_code, :string
  end
end
