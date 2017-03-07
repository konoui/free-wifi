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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160628135947) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "spots", force: :cascade do |t|
    t.string    "category"
    t.string    "ja_spot_name",                                                            null: false
    t.string    "ja_address",                                                              null: false
    t.string    "en_spot_name"
    t.string    "en_address"
    t.string    "business_hours"
    t.string    "restriction"
    t.string    "procedures"
    t.string    "ssid"
    t.string    "web_site"
    t.geography "lonlat",         limit: {:srid=>4326, :type=>"point", :geographic=>true}, null: false
  end

end