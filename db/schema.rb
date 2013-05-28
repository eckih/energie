# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130528065202) do

  create_table "typbezs", :force => true do |t|
    t.string   "bezeichnung"
    t.string   "kurzbezeichnung"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "typen", :force => true do |t|
    t.string   "bezeichnung"
    t.string   "link"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "werte", :force => true do |t|
    t.float    "stand"
    t.integer  "zaehler_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.date     "datum"
  end

  create_table "zaehlers", :force => true do |t|
    t.integer  "nummer"
    t.string   "bezeichnung"
    t.string   "kurzbezeichnung"
    t.string   "standort"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "typ_id"
    t.integer  "faktor"
    t.integer  "typbez_id"
  end

end
