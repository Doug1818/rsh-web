class RemoveSmallStepActivity < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.table_exists? 'small_step_activities'
      drop_table :small_step_activities
    end
  end
end
