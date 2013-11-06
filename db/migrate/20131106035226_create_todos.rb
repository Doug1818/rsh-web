class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.integer :program_id
      t.text :body
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
