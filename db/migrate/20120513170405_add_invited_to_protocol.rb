class AddInvitedToProtocol < ActiveRecord::Migration
  def self.up
    add_column :protocols, :invited, :text, :default => ""
  end

  def self.down
    remove_column :protocols, :invited
  end
end
