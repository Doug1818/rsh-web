class RemoveSmallStepIdFromCheckIns < ActiveRecord::Migration
  def change
    remove_column :check_ins, :small_step_id
  end
end
