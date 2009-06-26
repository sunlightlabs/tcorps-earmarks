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

ActiveRecord::Schema.define(:version => 20090626161948) do

  create_table "entities", :force => true do |t|
    t.integer  "letter_id"
    t.string   "name"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entities", ["letter_id"], :name => "index_entities_on_letter_id"

  create_table "legislators", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "letters", :force => true do |t|
    t.decimal  "amount"
    t.string   "project_title"
    t.integer  "fiscal_year"
    t.text     "funding_purpose"
    t.text     "taxpayer_justification"
    t.integer  "user_id"
    t.integer  "source_doc_id"
    t.string   "task_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "letters", ["amount"], :name => "index_letters_on_amount"
  add_index "letters", ["fiscal_year"], :name => "index_letters_on_fiscal_year"
  add_index "letters", ["source_doc_id"], :name => "index_letters_on_source_doc_id"
  add_index "letters", ["user_id"], :name => "index_letters_on_user_id"

  create_table "source_docs", :force => true do |t|
    t.string   "title"
    t.string   "source_url"
    t.string   "source_file"
    t.integer  "scribd_doc_id"
    t.string   "access_key"
    t.text     "plain_text"
    t.integer  "legislator_id"
    t.integer  "letters_count",     :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "conversion_failed", :default => false
    t.integer  "plain_text_length"
  end

  add_index "source_docs", ["conversion_failed"], :name => "index_source_docs_on_conversion_failed"
  add_index "source_docs", ["legislator_id"], :name => "index_source_docs_on_legislator_id"
  add_index "source_docs", ["letters_count"], :name => "index_source_docs_on_letters_count"
  add_index "source_docs", ["plain_text_length"], :name => "index_source_docs_on_plain_text_length"
  add_index "source_docs", ["scribd_doc_id"], :name => "index_source_docs_on_scribd_doc_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
