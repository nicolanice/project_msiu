class DegreesEmployees < ActiveRecord::Migration
  def change
    create_table :degrees_employees do |t|
         t.integer :degree_id
         t.integer :employee_id
    end
  end
end
