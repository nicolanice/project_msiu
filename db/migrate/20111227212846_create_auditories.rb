class CreateAuditories < ActiveRecord::Migration
  def change
    create_table :auditories do |t|
      t.string :number
    end
  end
end
