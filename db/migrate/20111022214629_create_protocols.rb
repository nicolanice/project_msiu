class CreateProtocols < ActiveRecord::Migration
  def change
    create_table :protocols do |t|
      t.integer :chairman_id
      t.integer :secretary_id
      t.references :protocol_template
      t.references :auditory
      t.timestamp :date
      t.integer :state
      t.timestamps
    end
    add_index :protocols, :auditory_id
    add_index :protocols, :protocol_template_id
  end
end
