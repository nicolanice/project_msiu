class AddDeletedToEmployee < ActiveRecord::Migration
  def self.up
    add_column :employees, :deleted, :boolean, :default => false
  end

  def self.down
    remove_column :employees, :deleted
  end
end
