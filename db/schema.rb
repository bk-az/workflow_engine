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

ActiveRecord::Schema.define(version: 20190807065639) do

  create_table "audits", force: :cascade do |t|
    t.integer  "auditable_id",    limit: 4
    t.string   "auditable_type",  limit: 255
    t.integer  "associated_id",   limit: 4
    t.string   "associated_type", limit: 255
    t.integer  "user_id",         limit: 4
    t.string   "user_type",       limit: 255
    t.string   "username",        limit: 255
    t.string   "action",          limit: 255
    t.text     "audited_changes", limit: 65535
    t.integer  "version",         limit: 4,     default: 0
    t.string   "comment",         limit: 255
    t.string   "remote_address",  limit: 255
    t.string   "request_uuid",    limit: 255
    t.datetime "created_at"
  end

  add_index "audits", ["associated_type", "associated_id"], name: "associated_index", using: :btree
  add_index "audits", ["auditable_type", "auditable_id", "version"], name: "auditable_index", using: :btree
  add_index "audits", ["created_at"], name: "index_audits_on_created_at", using: :btree
  add_index "audits", ["request_uuid"], name: "index_audits_on_request_uuid", using: :btree
  add_index "audits", ["user_id", "user_type"], name: "user_index", using: :btree

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
    t.string   "subdomain",   limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "owner_id",    limit: 4
  end

  add_index "companies", ["subdomain"], name: "index_companies_on_subdomain", using: :btree

  create_table "documents", force: :cascade do |t|
    t.string   "path",                  limit: 255, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "company_id",            limit: 4,   null: false
    t.integer  "documentable_id",       limit: 4
    t.string   "documentable_type",     limit: 255
    t.string   "document_file_name",    limit: 255
    t.string   "document_content_type", limit: 255
    t.integer  "document_file_size",    limit: 4
    t.datetime "document_updated_at"
  end

  add_index "documents", ["company_id"], name: "index_documents_on_company_id", using: :btree
  add_index "documents", ["documentable_type", "documentable_id"], name: "index_documents_on_documentable_type_and_documentable_id", using: :btree

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

  create_table "issue_watchers", force: :cascade do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "watcher_id",   limit: 4
    t.string   "watcher_type", limit: 255
    t.integer  "issue_id",     limit: 4
  end

  add_index "issue_watchers", ["issue_id"], name: "index_issue_watchers_on_issue_id", using: :btree
  add_index "issue_watchers", ["watcher_id", "watcher_type", "issue_id"], name: "index_issue_watchers_on_watcher_id_and_watcher_type_and_issue_id", unique: true, using: :btree
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
    t.integer  "issue_state_id",  limit: 4
    t.integer  "issue_type_id",   limit: 4
  end

  add_index "issues", ["assignee_id"], name: "index_issues_on_assignee_id", using: :btree
  add_index "issues", ["company_id"], name: "index_issues_on_company_id", using: :btree
  add_index "issues", ["creator_id"], name: "index_issues_on_creator_id", using: :btree
  add_index "issues", ["issue_state_id"], name: "index_issues_on_issue_state_id", using: :btree
  add_index "issues", ["issue_type_id"], name: "index_issues_on_issue_type_id", using: :btree
  add_index "issues", ["parent_issue_id"], name: "index_issues_on_parent_issue_id", using: :btree
  add_index "issues", ["project_id"], name: "index_issues_on_project_id", using: :btree

  create_table "project_memberships", force: :cascade do |t|
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "project_member_id",   limit: 4,   null: false
    t.string   "project_member_type", limit: 255, null: false
    t.integer  "project_id",          limit: 4,   null: false
  end

  add_index "project_memberships", ["project_id"], name: "index_project_memberships_on_project_id", using: :btree
  add_index "project_memberships", ["project_member_type", "project_member_id", "project_id"], name: "index_project_memberships_on_project_member_and_project_id", unique: true, using: :btree
  add_index "project_memberships", ["project_member_type", "project_member_id"], name: "index_project_memberships_on_project_member_type_and_id", using: :btree

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

  create_table "team_memberships", force: :cascade do |t|
    t.boolean  "is_team_admin", limit: 1, default: false
    t.boolean  "is_approved",   limit: 1, default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "team_id",       limit: 4
    t.integer  "user_id",       limit: 4
  end

  add_index "team_memberships", ["team_id", "user_id"], name: "index_team_memberships_on_team_id_and_user_id", unique: true, using: :btree
  add_index "team_memberships", ["team_id"], name: "index_team_memberships_on_team_id", using: :btree
  add_index "team_memberships", ["user_id"], name: "index_team_memberships_on_user_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",         limit: 255, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "company_id",   limit: 4,   null: false
    t.integer  "sequence_num", limit: 4,   null: false
  end

  add_index "teams", ["company_id"], name: "index_teams_on_company_id", using: :btree
  add_index "teams", ["sequence_num", "company_id"], name: "index_teams_on_sequence_num_and_company_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",                         limit: 255,                null: false
    t.string   "last_name",                          limit: 255,                null: false
    t.string   "designation",                        limit: 255
    t.boolean  "has_changed_sys_generated_password", limit: 1,   default: true, null: false
    t.string   "email",                              limit: 255, default: "",   null: false
    t.string   "encrypted_password",                 limit: 255, default: "",   null: false
    t.string   "reset_password_token",               limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      limit: 4,   default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",                 limit: 255
    t.string   "last_sign_in_ip",                    limit: 255
    t.string   "confirmation_token",                 limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",                  limit: 255
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.integer  "company_id",                         limit: 4
    t.integer  "role_id",                            limit: 4,                  null: false
    t.boolean  "is_active",                          limit: 1,   default: true, null: false
  end

  add_index "users", ["company_id"], name: "index_users_on_company_id", using: :btree
  add_index "users", ["email", "company_id"], name: "index_users_on_email_and_company_id", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

end
