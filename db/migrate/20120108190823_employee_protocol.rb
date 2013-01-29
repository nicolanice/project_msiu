class EmployeeProtocol < ActiveRecord::Migration
  def up
     create_table :employees_protocols, :id => false do |t|
	      t.integer :protocol_id
	      t.integer :employee_id
    end
  end

  def down
  end
end
