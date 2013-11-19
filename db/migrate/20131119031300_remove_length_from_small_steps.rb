class RemoveLengthFromSmallSteps < ActiveRecord::Migration
  def change
    remove_column :small_steps, :length
  end
end
