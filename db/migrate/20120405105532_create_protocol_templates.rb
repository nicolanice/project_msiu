class CreateProtocolTemplates < ActiveRecord::Migration
  def change
    create_table :protocol_templates do |t|
      t.text :body

      t.timestamps
    end
  end
end
