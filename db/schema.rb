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

ActiveRecord::Schema.define(:version => 20130802070213) do

  create_table "campus", :force => true do |t|
    t.string   "code",        :limit => 3
    t.string   "description", :limit => 30
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "colleges", :force => true do |t|
    t.string   "code",        :limit => 2
    t.string   "description", :limit => 30
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "course_offerings", :force => true do |t|
    t.string   "crn",           :limit => 5
    t.boolean  "active"
    t.integer  "term_id"
    t.integer  "department_id"
    t.integer  "instructor_id"
    t.integer  "college_id"
    t.integer  "course_id"
    t.integer  "grading_id"
    t.integer  "term_type_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "courses", :force => true do |t|
    t.integer  "subject_id"
    t.string   "number",            :limit => 5
    t.string   "title",             :limit => 30
    t.integer  "effective_term_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "departments", :force => true do |t|
    t.string   "code",        :limit => 4
    t.string   "description", :limit => 30
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "grading_types", :force => true do |t|
    t.string   "code",        :limit => 1
    t.string   "description", :limit => 30
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "instructors", :force => true do |t|
    t.string   "instructor_id",  :limit => 9
    t.string   "last_name",      :limit => 60
    t.string   "first_name",     :limit => 60
    t.string   "middle_initial", :limit => 1
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "sections", :force => true do |t|
    t.string   "sequence",          :limit => 3
    t.integer  "max_enrollment"
    t.integer  "actual_enrollment"
    t.boolean  "active"
    t.integer  "campus_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "subjects", :force => true do |t|
    t.string   "code",        :limit => 4
    t.string   "description", :limit => 30
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "term_types", :force => true do |t|
    t.string   "code",        :limit => 3
    t.string   "description", :limit => 30
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "terms", :force => true do |t|
    t.string   "code",        :limit => 6
    t.string   "description", :limit => 30
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

end
