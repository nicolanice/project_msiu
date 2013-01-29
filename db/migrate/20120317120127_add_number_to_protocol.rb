class AddNumberToProtocol < ActiveRecord::Migration
  def self.up
    add_column :protocols, :number, :integer, :default => false
  end

  def self.down
    remove_column :protocols, :number
  end
end
