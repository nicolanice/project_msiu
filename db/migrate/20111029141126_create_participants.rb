class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
         t.integer :theme_id
	       t.integer :employee_id
	       t.text    :message
	       t.integer :party_type  # 0 - listen, 1 - speak, ...
      t.timestamps
    end
  end
end
