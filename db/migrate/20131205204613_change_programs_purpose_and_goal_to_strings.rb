class ChangeProgramsPurposeAndGoalToStrings < ActiveRecord::Migration
  def change
    change_column :programs, :purpose, :string
    change_column :programs, :goal, :string
  end
end
