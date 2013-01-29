class CreateAcademicTitles < ActiveRecord::Migration
  def change
    create_table :academic_titles do |t|
      t.string :name
      t.string :short_name
    end
  end
end
