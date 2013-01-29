class AddIsFillToProtocol < ActiveRecord::Migration
   def self.up
     add_column :protocols, :is_fill, :boolean, :default => false
  end

  def self.down
    remove_column :protocols, :is_fill
  end
end
