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

ActiveRecord::Schema.define(:version => 20130327095332) do

  create_table "users", :force => true do |t|
    t.string   "nom"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.integer  "poids",              :default => 0,            :null => false
    t.integer  "poids_ideal",        :default => 0,            :null => false
    t.integer  "taille",             :default => 0,            :null => false
    t.boolean  "fumeur",             :default => false,        :null => false
    t.boolean  "souhaite_arreter",   :default => false,        :null => false
    t.date     "dte_naissance",      :default => '1900-01-01', :null => false
    t.string   "cv_file_name"
    t.string   "cv_content_type"
    t.integer  "cv_file_size"
    t.datetime "cv_updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
