class AddDaysToSmallSteps < ActiveRecord::Migration
  def change
    add_column :small_steps, :days, :integer, default: 7
  end
end
