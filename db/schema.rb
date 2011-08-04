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

ActiveRecord::Schema.define(:version => 20110628064815) do

  create_table "boards", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
    t.decimal  "board_size",      :default => 9.0
    t.text     "recommendations"
    t.text     "played_words"
  end

# Could not dump table "games" because of following StandardError
#   Unknown type 'board' for column 'current_board'

  create_table "recommendations", :force => true do |t|
    t.string   "word"
    t.integer  "board_id"
    t.decimal  "score"
    t.decimal  "panda_score"
    t.decimal  "rank"
    t.decimal  "word_score"
    t.text     "spots"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
