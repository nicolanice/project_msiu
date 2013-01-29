class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.references :protocol
      t.text :description
      t.text :decided

      t.timestamps
    end
    add_index :themes, :protocol_id
  end
end
