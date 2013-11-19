class AddProgramIdToSmallSteps < ActiveRecord::Migration
  def change
    add_column :small_steps, :program_id, :integer
  end
end
