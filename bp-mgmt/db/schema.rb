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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_160_916_020_855) do
  create_table 'arena_services', force: :cascade do |t|
    t.string   'address',    null: false
    t.integer  'port',       null: false
    t.string   'version'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'pet_contests', force: :cascade do |t|
    t.string   'contest_type', null: false
    t.string   'workflow_state'
    t.integer  'challenger_id'
    t.integer  'challenged_id'
    t.integer  'winner_id'
    t.datetime 'created_at',     null: false
    t.datetime 'updated_at',     null: false
    t.index ['challenged_id'], name: 'index_pet_contests_on_challenged_id'
    t.index ['challenger_id'], name: 'index_pet_contests_on_challenger_id'
    t.index ['winner_id'], name: 'index_pet_contests_on_winner_id'
  end

  create_table 'pets', force: :cascade do |t|
    t.integer  'user_id'
    t.string   'name',           null: false
    t.string   'pet_type',       null: false
    t.string   'workflow_state'
    t.integer  'strength',       null: false
    t.integer  'wit',            null: false
    t.integer  'senses',         null: false
    t.integer  'agility',        null: false
    t.integer  'experience',     null: false
    t.datetime 'created_at',     null: false
    t.datetime 'updated_at',     null: false
    t.index ['user_id'], name: 'index_pets_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string   'email',               default: '', null: false
    t.string   'encrypted_password',  default: '', null: false
    t.datetime 'remember_created_at'
    t.integer  'sign_in_count', default: 0, null: false
    t.datetime 'current_sign_in_at'
    t.datetime 'last_sign_in_at'
    t.string   'current_sign_in_ip'
    t.string   'last_sign_in_ip'
    t.datetime 'created_at',                       null: false
    t.datetime 'updated_at',                       null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
  end
end
