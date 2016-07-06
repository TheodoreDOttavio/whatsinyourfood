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

ActiveRecord::Schema.define(version: 20160706061335) do

  create_table "players", force: :cascade do |t|
    t.string   "name",       default: "no name"
    t.string   "sucesses"
    t.string   "failures"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "upc"
    t.string   "brand_name"
    t.string   "item_name"
    t.string   "brand_id"
    t.string   "item_id"
    t.string   "item_description"
    t.string   "nf_ingredient_statement"
    t.integer  "nf_calories"
    t.integer  "nf_calories_from_fat"
    t.integer  "nf_total_fat"
    t.integer  "nf_saturated_fat"
    t.integer  "nf_trans_fatty_acid"
    t.integer  "nf_polyunsaturated_fat"
    t.integer  "nf_monounsaturated_fat"
    t.integer  "nf_cholesterol"
    t.integer  "nf_sodium"
    t.integer  "nf_total_carbohydrate"
    t.integer  "nf_dietary_fiber"
    t.integer  "nf_sugars"
    t.integer  "nf_protein"
    t.integer  "nf_vitamin_a_dv"
    t.integer  "nf_vitamin_c_dv"
    t.integer  "nf_calcium_dv"
    t.integer  "nf_iron_dv"
    t.integer  "nf_potassium"
    t.integer  "nf_servings_per_container"
    t.decimal  "nf_serving_size_qty"
    t.string   "nf_serving_size_unit"
    t.decimal  "nf_serving_weight_grams"
    t.decimal  "metric_qty"
    t.string   "metric_uom"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "quests", force: :cascade do |t|
    t.string   "upc"
    t.string   "manufacturer"
    t.string   "name"
    t.string   "size"
    t.boolean  "is_associated"
    t.boolean  "is_searched"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "topics", force: :cascade do |t|
    t.string   "question"
    t.string   "statement"
    t.boolean  "qtype"
    t.string   "test_field"
    t.integer  "sucesses"
    t.integer  "failures"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
