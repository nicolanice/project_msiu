class AddDatesToProtocolTemplate < ActiveRecord::Migration
  def self.up
    add_column :protocol_templates, :apply_from, :timestamps, :default => Time.now
    add_column :protocol_templates, :apply_to, :timestamps, :default => Time.now
  end

  def self.down
    remove_column :protocol_templates, :apply_from
    remove_column :protocol_templates, :apply_to
  end
end
