class AddReferralCodesToPractice < ActiveRecord::Migration
  def change
    add_column :practices, :referral_code, :string
    add_column :practices, :referred_by_code, :string
  end
end
