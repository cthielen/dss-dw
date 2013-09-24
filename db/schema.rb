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

ActiveRecord::Schema.define(:version => 20130924220514) do

  create_table "api_key_users", :force => true do |t|
    t.string   "secret"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "name"
    t.datetime "logged_in_at"
  end

  add_index "api_key_users", ["name", "secret"], :name => "index_api_key_users_on_name_and_secret"
  add_index "api_key_users", ["name"], :name => "index_api_key_users_on_name"

  create_table "api_whitelisted_ip_users", :force => true do |t|
    t.string   "address"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.text     "reason"
    t.datetime "logged_in_at"
  end

  add_index "api_whitelisted_ip_users", ["address"], :name => "index_api_whitelisted_ip_users_on_address"

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

  add_index "departments", ["code"], :name => "index_departments_on_code"

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

  create_table "majors", :force => true do |t|
    t.string   "code"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "people", :force => true do |t|
    t.string   "d_first"
    t.string   "d_last"
    t.string   "loginid"
    t.string   "email"
    t.string   "phone"
    t.string   "address"
    t.integer  "iam_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "d_middle"
    t.string   "o_first"
    t.string   "o_middle"
    t.string   "o_last"
    t.boolean  "is_faculty"
    t.boolean  "is_staff"
    t.boolean  "is_student"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "major_id"
    t.integer  "college_id"
    t.integer  "department_id"
    t.integer  "title_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.boolean  "is_pps"
    t.boolean  "is_sis"
    t.integer  "person_id"
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

  add_index "terms", ["code"], :name => "index_terms_on_code"

  create_table "titles", :force => true do |t|
    t.string   "code"
    t.string   "o_name"
    t.string   "d_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
