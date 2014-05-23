class AddCoachAndUserIdsToAccomplishments < ActiveRecord::Migration
  def change
    add_column :accomplishments, :coach_id, :integer
    add_column :accomplishments, :user_id, :integer
  end
end
