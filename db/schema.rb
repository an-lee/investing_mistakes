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

ActiveRecord::Schema.define(version: 2018_07_08_014713) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "assets", comment: "虚拟资产", force: :cascade do |t|
    t.bigint "owner_id", comment: "所有者"
    t.string "uuid", comment: "Mixin网络中的唯一标识"
    t.string "chain_id", comment: "链ID"
    t.string "symbol", comment: "简称"
    t.string "name", comment: "全称"
    t.string "icon_url", comment: "图标链接"
    t.string "balance", comment: "余额"
    t.string "public_key", comment: "公钥"
    t.string "price_btc", comment: "单价，以 BTC 计价"
    t.string "price_usd", comment: "单价，以  USD 计价"
    t.string "change_btc", comment: "以 BTC 计价变动"
    t.string "change_usd", comment: "以 USD 计价变动"
    t.string "asset_key"
    t.string "confirmations", comment: "确认数"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_assets_on_owner_id"
  end

  create_table "posts", comment: "帖子", force: :cascade do |t|
    t.bigint "author_id", comment: "作者"
    t.text "should", comment: "本应"
    t.text "but", comment: "但是"
    t.text "result", comment: "结果"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_posts_on_author_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "uid", comment: "mixin 的 user_id"
    t.json "raw", comment: "mixin 返回的原始数据"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_users_on_uid", unique: true
  end

  add_foreign_key "assets", "users", column: "owner_id"
  add_foreign_key "posts", "users", column: "author_id"
end
