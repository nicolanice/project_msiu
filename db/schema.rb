# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120617111552) do

  create_table "academic_titles", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "auditories", :force => true do |t|
    t.string "number"
  end

  create_table "degrees", :force => true do |t|
    t.string  "name"
    t.integer "employee_id"
  end

  add_index "degrees", ["employee_id"], :name => "index_degrees_on_employee_id"

  create_table "degrees_employees", :force => true do |t|
    t.integer "degree_id"
    t.integer "employee_id"
  end

  create_table "dictionaries", :force => true do |t|
    t.string   "word"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "emails", :force => true do |t|
    t.string  "email"
    t.integer "user_id"
  end

  add_index "emails", ["user_id"], :name => "index_emails_on_user_id"

  create_table "employees", :force => true do |t|
    t.string   "f"
    t.string   "i"
    t.string   "o"
    t.integer  "post_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deleted",           :default => false
    t.integer  "academic_title_id"
    t.integer  "user_id"
  end

  add_index "employees", ["academic_title_id"], :name => "index_employees_on_academic_title_id"
  add_index "employees", ["post_id"], :name => "index_employees_on_post_id"
  add_index "employees", ["user_id"], :name => "index_employees_on_user_id"

  create_table "employees_protocols", :id => false, :force => true do |t|
    t.integer "protocol_id"
    t.integer "employee_id"
  end

  create_table "participants", :force => true do |t|
    t.integer  "theme_id"
    t.integer  "employee_id"
    t.text     "message"
    t.integer  "party_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string "name"
    t.string "short_name"
  end

  create_table "protocol_templates", :force => true do |t|
    t.text      "body"
    t.datetime  "created_at"
    t.datetime  "updated_at"
    t.string    "name",       :default => "Template"
    t.timestamp "apply_from", :default => '2012-04-26 15:24:30'
    t.timestamp "apply_to",   :default => '2012-04-26 15:24:30'
  end

  create_table "protocols", :force => true do |t|
    t.integer  "chairman_id"
    t.integer  "secretary_id"
    t.integer  "protocol_template_id"
    t.integer  "auditory_id"
    t.datetime "date"
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "signed",               :default => false
    t.boolean  "is_fill",              :default => false
    t.integer  "number",               :default => 0
    t.integer  "count_themes",         :default => 0
    t.text     "invited"
    t.integer  "ac_year",              :default => 0
  end

  add_index "protocols", ["auditory_id"], :name => "index_protocols_on_auditory_id"
  add_index "protocols", ["protocol_template_id"], :name => "index_protocols_on_protocol_template_id"

  create_table "searches", :force => true do |t|
    t.integer  "year"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "themes", :force => true do |t|
    t.integer  "protocol_id"
    t.text     "description"
    t.text     "decided"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "themes", ["protocol_id"], :name => "index_themes_on_protocol_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.integer  "role",                                     :default => 0
    t.integer  "employee_id"
  end

  add_index "users", ["employee_id"], :name => "index_users_on_employee_id"
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
