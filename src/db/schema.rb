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

ActiveRecord::Schema.define(:version => 20080725154610) do

  create_table "activities", :force => true do |t|
    t.string   "name",                           :default => "", :null => false
    t.text     "note"
    t.integer  "user_id",          :limit => 11
    t.integer  "deck_id",          :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "study_session_id", :limit => 11
  end

  create_table "cardies", :force => true do |t|
    t.string   "super"
    t.string   "thing"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bob"
  end

  create_table "cards", :force => true do |t|
    t.text     "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deck_id",     :limit => 11
    t.string   "instruction"
  end

  add_index "cards", ["deck_id"], :name => "index_cards_on_deck_id"

  create_table "curriculums", :force => true do |t|
    t.integer  "user_id",    :limit => 11
    t.integer  "deck_id",    :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "curriculums", ["deck_id"], :name => "index_curriculums_on_deck_id"
  add_index "curriculums", ["user_id"], :name => "index_curriculums_on_user_id"

  create_table "decks", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",     :limit => 11
    t.string   "visibility"
    t.string   "instruction"
  end

  add_index "decks", ["user_id"], :name => "index_decks_on_user_id"

  create_table "ext_cards", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.text     "message"
    t.integer  "deck_id",    :limit => 11
    t.integer  "user_id",    :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["deck_id"], :name => "index_messages_on_deck_id"
  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "multi_choice_options", :force => true do |t|
    t.string   "option"
    t.integer  "card_id",    :limit => 11,                    :null => false
    t.boolean  "correct",                  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued",     :limit => 11
    t.integer "lifetime",   :limit => 11
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :limit => 11,                 :null => false
    t.string  "server_url"
    t.string  "salt",                     :default => "", :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "role_id",    :limit => 11, :null => false
    t.integer  "user_id",    :limit => 11, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "rolename"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rumination_results", :force => true do |t|
    t.string "name"
    t.text   "description"
  end

  create_table "ruminations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rumination_result_id", :limit => 11
    t.integer  "card_id",              :limit => 11
    t.integer  "study_session_id",     :limit => 11, :null => false
  end

  add_index "ruminations", ["rumination_result_id"], :name => "index_ruminations_on_rumination_result_id"
  add_index "ruminations", ["card_id"], :name => "index_ruminations_on_card_id"
  add_index "ruminations", ["study_session_id"], :name => "index_ruminations_on_study_session_id"

  create_table "study_modes", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "study_sessions", :force => true do |t|
    t.integer  "user_id",       :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "study_mode_id", :limit => 11, :null => false
    t.integer  "deck_id",       :limit => 11
  end

  add_index "study_sessions", ["user_id"], :name => "index_study_sessions_on_user_id"
  add_index "study_sessions", ["deck_id"], :name => "index_study_sessions_on_deck_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id",               :limit => 11
    t.date     "start_subscription_at"
    t.date     "end_subscription_at"
    t.text     "transcation"
    t.date     "created_at"
    t.datetime "updated_at"
    t.string   "type",                                :default => "", :null => false
  end

  create_table "super_cards", :force => true do |t|
    t.string   "stuff"
    t.string   "otherstuff"
    t.integer  "thing",      :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supermemo_states", :force => true do |t|
    t.date     "train_date"
    t.float    "interval",                      :default => 0.0
    t.float    "easiness_factor",               :default => 2.5
    t.integer  "repetition",      :limit => 11, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "card_id",         :limit => 11
    t.integer  "user_id",         :limit => 11
    t.integer  "rumination_id",   :limit => 11
  end

  add_index "supermemo_states", ["card_id"], :name => "index_supermemo_states_on_card_id"
  add_index "supermemo_states", ["user_id"], :name => "index_supermemo_states_on_user_id"
  add_index "supermemo_states", ["rumination_id"], :name => "index_supermemo_states_on_rumination_id"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",           :limit => 40
    t.string   "salt",                       :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",            :limit => 40
    t.datetime "activated_at"
    t.string   "password_reset_code",        :limit => 40
    t.boolean  "enabled",                                  :default => true
    t.string   "identity_url"
    t.integer  "study_mode_id",              :limit => 11, :default => 3
    t.datetime "last_signin_at"
    t.datetime "last_notification_email_at"
    t.boolean  "notification_enabled",                     :default => true
    t.string   "time_zone",                                :default => "UTC"
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end
