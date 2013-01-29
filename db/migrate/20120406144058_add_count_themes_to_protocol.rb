class AddCountThemesToProtocol < ActiveRecord::Migration
  def self.up
    add_column :protocols, :count_themes, :integer, :default => 0
  end

  def self.down
    remove_column :protocols, :count_themes
  end
end
