class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :email
      t.references :user
    end
    add_index :emails, :user_id
  end
end
