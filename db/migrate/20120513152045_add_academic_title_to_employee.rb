class AddAcademicTitleToEmployee < ActiveRecord::Migration
  def self.up
    add_column :employees, :academic_title_id, :integer
    add_index :employees, :academic_title_id
  end

  def self.down
    remove_column :employees, :academic_title_id
  end
end
