class AddAcademicYearToProtocol < ActiveRecord::Migration
  def self.up
    add_column :protocols, :ac_year, :integer, :default => false
  end

  def self.down
    remove_column :protocols, :ac_year
  end
end
