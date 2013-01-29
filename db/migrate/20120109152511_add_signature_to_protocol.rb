class AddSignatureToProtocol < ActiveRecord::Migration
  def self.up
     add_column :protocols, :signed, :boolean, :default => false
  end

  def self.down
    remove_column :protocols, :signed
  end
end
