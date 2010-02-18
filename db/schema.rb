# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100218095445) do

  create_table "applicant_characters", :force => true do |t|
    t.integer "applicant_id"
    t.integer "server_id",           :null => false
    t.string  "current_name",        :null => false
    t.string  "wow_class",           :null => false
    t.string  "current_race"
    t.string  "armory_link",         :null => false
    t.boolean "original_owner"
    t.text    "previous_guilds"
    t.text    "reasons_for_leaving"
    t.text    "pve_experience"
    t.text    "pvp_experience"
    t.string  "screenshot_link"
  end

  add_index "applicant_characters", ["applicant_id"], :name => "index_applicant_characters_on_applicant_id"
  add_index "applicant_characters", ["current_name"], :name => "index_applicant_characters_on_current_name"

  create_table "applicant_personals", :force => true do |t|
    t.integer "applicant_id"
    t.string  "name"
    t.integer "age"
    t.string  "time_zone"
    t.time    "start_sunday"
    t.time    "end_sunday"
    t.time    "start_monday"
    t.time    "end_monday"
    t.time    "start_tuesday"
    t.time    "end_tuesday"
    t.time    "start_wednesday"
    t.time    "end_wednesday"
    t.time    "start_thursday"
    t.time    "end_thursday"
    t.time    "start_friday"
    t.time    "end_friday"
    t.time    "start_saturday"
    t.time    "end_saturday"
    t.text    "known_members"
    t.text    "future_commitments"
    t.text    "reasons_for_joining"
  end

  add_index "applicant_personals", ["applicant_id"], :name => "index_applicant_personals_on_applicant_id"

  create_table "applicant_systems", :force => true do |t|
    t.integer "applicant_id"
    t.string  "connection_type"
    t.boolean "has_microphone"
    t.boolean "has_ventrilo"
    t.boolean "uses_ventrilo"
  end

  add_index "applicant_systems", ["applicant_id"], :name => "index_applicant_systems_on_applicant_id"

  create_table "applicants", :force => true do |t|
    t.string   "status",     :default => "new"
    t.integer  "user_id"
    t.integer  "topic_id"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "applicants", ["topic_id"], :name => "index_applicants_on_topic_id"
  add_index "applicants", ["user_id"], :name => "index_applicants_on_user_id"

  create_table "servers", :force => true do |t|
    t.string "region",  :default => "us", :null => false
    t.string "name",                      :null => false
    t.string "ruleset"
  end

  add_index "servers", ["name"], :name => "index_servers_on_name"

end
