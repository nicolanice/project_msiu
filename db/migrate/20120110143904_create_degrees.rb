class CreateDegrees < ActiveRecord::Migration
  def change
    create_table :degrees do |t|
      t.string :name
      t.references :employee
    end
    add_index :degrees, :employee_id
  end
end
