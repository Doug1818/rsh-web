class RemoveReferralCodesFromPractices < ActiveRecord::Migration
  def change
  	remove_column :practices, :referral_code
    remove_column :practices, :referred_by_code
  end
end
