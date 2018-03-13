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

ActiveRecord::Schema.define(version: 20151112122331) do

  create_table "answers", force: true do |t|
    t.string   "ans"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_id"
    t.integer  "student_id"
    t.string   "picture"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["student_id"], name: "index_answers_on_student_id", using: :btree

  create_table "badges", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_id"
    t.integer  "chapter_id"
  end

  create_table "chapters", force: true do |t|
    t.string   "name"
    t.string   "badge_name"
    t.string   "badge_image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organizer_id"
    t.string   "attachment"
    t.text     "description"
  end

  add_index "chapters", ["organizer_id"], name: "index_chapters_on_organizer_id", using: :btree

  create_table "completeds", force: true do |t|
    t.integer  "take_score"
    t.boolean  "isview"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_id"
    t.integer  "lesson_id"
  end

  create_table "glossaries", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "syntax"
    t.text     "example"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organizer_id"
  end

  add_index "glossaries", ["organizer_id"], name: "index_glossaries_on_organizer_id", using: :btree

  create_table "instructions", force: true do |t|
    t.string   "command"
    t.text     "example"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lesson_id"
    t.integer  "statement"
  end

  add_index "instructions", ["lesson_id"], name: "index_instructions_on_lesson_id", using: :btree

  create_table "lessons", force: true do |t|
    t.string   "name"
    t.text     "theory"
    t.text     "theory_example"
    t.text     "instruction"
    t.text     "answer"
    t.text     "code"
    t.integer  "score"
    t.integer  "sub_score"
    t.boolean  "is_exercise"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "chapter_id"
    t.integer  "organizer_id"
  end

  add_index "lessons", ["chapter_id"], name: "index_lessons_on_chapter_id", using: :btree
  add_index "lessons", ["organizer_id"], name: "index_lessons_on_organizer_id", using: :btree

  create_table "media", force: true do |t|
    t.string   "name"
    t.string   "attachment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organizer_id"
    t.string   "video"
  end

  add_index "media", ["organizer_id"], name: "index_media_on_organizer_id", using: :btree

  create_table "organizers", force: true do |t|
    t.string   "fullname"
    t.string   "email"
    t.string   "password"
    t.string   "picture"
    t.string   "major"
    t.text     "about_me"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment"
    t.integer  "type"
  end

  create_table "questions", force: true do |t|
    t.text     "ques"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_id"
    t.string   "title"
    t.string   "picture"
    t.string   "category"
  end

  add_index "questions", ["student_id"], name: "index_questions_on_student_id", using: :btree

  create_table "students", force: true do |t|
    t.string   "fullname"
    t.string   "email"
    t.string   "username"
    t.string   "password"
    t.string   "picture"
    t.string   "location"
    t.integer  "total_score"
    t.text     "about"
    t.string   "last_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "social_id"
    t.boolean  "student_validate"
  end

  create_table "users", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "image"
    t.string   "token"
    t.datetime "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
