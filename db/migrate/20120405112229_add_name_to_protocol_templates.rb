class AddNameToProtocolTemplates < ActiveRecord::Migration
  def self.up
    add_column :protocol_templates, :name, :string, :default => "Template"
  end

  def self.down
    remove_column :protocol_templates, :name
  end
end
