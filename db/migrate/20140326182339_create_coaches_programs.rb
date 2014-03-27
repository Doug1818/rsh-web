class CreateCoachesPrograms < ActiveRecord::Migration
  def change
    create_table :coaches_programs, id: false do |t|
    	t.references :coach, null: false
      t.references :program, null: false
    end
  end
end
