class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :f
      t.string :i
      t.string :o      
      t.references :post

      t.timestamps
    end
    add_index :employees, :post_id
  end
end
