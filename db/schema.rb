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

ActiveRecord::Schema.define(version: 20190717210433) do

  create_table "comments", force: :cascade do |t|
    t.text     "content",          limit: 65535, null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "company_id",       limit: 4,     null: false
    t.integer  "user_id",          limit: 4
    t.integer  "commentable_id",   limit: 4
    t.string   "commentable_type", limit: 255
  end

  add_index "comments", ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
  add_index "comments", ["company_id"], name: "index_comments_on_company_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.string   "description", limit: 255
    t.string   "domain_name", limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "owner_id",    limit: 4,   null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string   "path",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "company_id", limit: 4,   null: false
    t.integer  "issue_id",   limit: 4,   null: false
  end

  add_index "documents", ["company_id"], name: "index_documents_on_company_id", using: :btree
  add_index "documents", ["issue_id"], name: "index_documents_on_issue_id", using: :btree

  create_table "issue_states", force: :cascade do |t|
    t.string  "name",       limit: 255, null: false
    t.integer "company_id", limit: 4,   null: false
    t.integer "issue_id",   limit: 4
  end

  add_index "issue_states", ["company_id"], name: "index_issue_states_on_company_id", using: :btree
  add_index "issue_states", ["issue_id"], name: "index_issue_states_on_issue_id", using: :btree

  create_table "issue_types", force: :cascade do |t|
    t.string  "name",       limit: 255, null: false
    t.integer "company_id", limit: 4,   null: false
    t.integer "project_id", limit: 4
  end

  add_index "issue_types", ["company_id"], name: "index_issue_types_on_company_id", using: :btree
  add_index "issue_types", ["project_id"], name: "index_issue_types_on_project_id", using: :btree

  create_table "issue_watchers", id: false, force: :cascade do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "watcher_id",   limit: 4
    t.string   "watcher_type", limit: 255
    t.integer  "issue_id",     limit: 4
  end

  add_index "issue_watchers", ["issue_id"], name: "index_issue_watchers_on_issue_id", using: :btree
  add_index "issue_watchers", ["watcher_type", "watcher_id"], name: "index_issue_watchers_on_watcher_type_and_watcher_id", using: :btree

  create_table "issues", force: :cascade do |t|
    t.string   "title",           limit: 255,               null: false
    t.text     "description",     limit: 65535,             null: false
    t.date     "start_date"
    t.date     "due_date"
    t.integer  "progress",        limit: 4,     default: 0
    t.integer  "priority",        limit: 4,     default: 0
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "company_id",      limit: 4,                 null: false
    t.integer  "creator_id",      limit: 4,                 null: false
    t.integer  "assignee_id",     limit: 4
    t.integer  "parent_issue_id", limit: 4
    t.integer  "project_id",      limit: 4
    t.integer  "issue_state_id",  limit: 4,                 null: false
    t.integer  "issue_type_id",   limit: 4,                 null: false
  end

  add_index "issues", ["assignee_id"], name: "index_issues_on_assignee_id", using: :btree
  add_index "issues", ["company_id"], name: "index_issues_on_company_id", using: :btree
  add_index "issues", ["creator_id"], name: "index_issues_on_creator_id", using: :btree
  add_index "issues", ["issue_state_id"], name: "index_issues_on_issue_state_id", using: :btree
  add_index "issues", ["issue_type_id"], name: "index_issues_on_issue_type_id", using: :btree
  add_index "issues", ["parent_issue_id"], name: "index_issues_on_parent_issue_id", using: :btree
  add_index "issues", ["project_id"], name: "index_issues_on_project_id", using: :btree

  create_table "project_memberships", id: false, force: :cascade do |t|
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "project_member_id",   limit: 4
    t.string   "project_member_type", limit: 255
    t.integer  "project_id",          limit: 4
  end

  add_index "project_memberships", ["project_id"], name: "index_project_memberships_on_project_id", using: :btree
  add_index "project_memberships", ["project_member_id"], name: "index_project_memberships_on_project_member_id", using: :btree
  add_index "project_memberships", ["project_member_type"], name: "index_project_memberships_on_project_member_type", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "title",       limit: 255,   null: false
    t.text     "description", limit: 65535, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "company_id",  limit: 4,     null: false
  end

  add_index "projects", ["company_id"], name: "index_projects_on_company_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "team_memberships", id: false, force: :cascade do |t|
    t.boolean  "is_team_admin", limit: 1, default: false
    t.boolean  "is_approved",   limit: 1, default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "team_id",       limit: 4
    t.integer  "user_id",       limit: 4
  end

  add_index "team_memberships", ["team_id"], name: "index_team_memberships_on_team_id", using: :btree
  add_index "team_memberships", ["user_id"], name: "index_team_memberships_on_user_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "company_id", limit: 4,   null: false
  end

  add_index "teams", ["company_id"], name: "index_teams_on_company_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             limit: 255,              null: false
    t.string   "last_name",              limit: 255,              null: false
    t.string   "designation",            limit: 255
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "company_id",             limit: 4
    t.integer  "role_id",                limit: 4,                null: false
  end

  add_index "users", ["company_id"], name: "index_users_on_company_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

end