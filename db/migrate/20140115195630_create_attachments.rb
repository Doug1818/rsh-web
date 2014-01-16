class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :small_step_id
      t.string :filename

      t.timestamps
    end
  end
end
