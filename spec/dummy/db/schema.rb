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

ActiveRecord::Schema.define(version: 20171113153050) do

  create_table "cities", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", limit: 128
    t.string "alternative_names", limit: 256
    t.string "iso_code", limit: 128
    t.integer "country_id"
    t.integer "region_id"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.integer "population"
    t.integer "priority", default: 1000
    t.boolean "show_in_api", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "operational", default: false
    t.index ["country_id"], name: "index_cities_on_country_id"
    t.index ["iso_code"], name: "index_cities_on_iso_code"
    t.index ["region_id"], name: "index_cities_on_region_id"
  end

  create_table "countries", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", limit: 128
    t.string "official_name", limit: 128
    t.string "iso_name", limit: 128
    t.string "fips", limit: 56
    t.string "iso_alpha_2", limit: 5
    t.string "iso_alpha_3", limit: 5
    t.string "itu_code", limit: 5
    t.string "dialing_prefix", limit: 56
    t.string "tld", limit: 16
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.string "capital", limit: 64
    t.string "continent", limit: 64
    t.string "currency_code", limit: 16
    t.string "currency_name", limit: 64
    t.string "is_independent", limit: 56
    t.string "languages", limit: 256
    t.integer "priority", default: 1000
    t.boolean "show_in_api", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "operational", default: false
    t.index ["fips"], name: "index_countries_on_fips"
    t.index ["iso_alpha_2"], name: "index_countries_on_iso_alpha_2"
    t.index ["iso_alpha_3"], name: "index_countries_on_iso_alpha_3"
  end

  create_table "devices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "registration_id"
    t.string "uuid", limit: 1024
    t.string "device_token", limit: 1024
    t.string "device_name", limit: 64
    t.string "device_type", limit: 64
    t.string "operating_system", limit: 64
    t.string "software_version", limit: 64
    t.datetime "last_accessed_at"
    t.string "last_accessed_api", limit: 1024
    t.integer "otp"
    t.datetime "otp_sent_at"
    t.string "api_token", limit: 256
    t.datetime "token_created_at"
    t.string "status", limit: 16, default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "otp_verified_at"
    t.datetime "tac_accepted_at"
    t.index ["registration_id"], name: "index_devices_on_registration_id"
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "documents", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "document"
    t.string "document_type"
    t.integer "documentable_id"
    t.string "documentable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_type"], name: "index_documents_on_document_type"
    t.index ["documentable_id", "documentable_type"], name: "index_documents_on_documentable_id_and_documentable_type"
  end

  create_table "features", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "status", limit: 16, default: "unpublished", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "categorisable", default: false
  end

  create_table "images", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "image"
    t.string "image_type"
    t.integer "imageable_id"
    t.string "imageable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["image_type"], name: "index_images_on_image_type"
    t.index ["imageable_id", "imageable_type"], name: "index_images_on_imageable_id_and_imageable_type"
  end

  create_table "import_data", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "importable_id"
    t.string "importable_type"
    t.string "data_type"
    t.string "status", limit: 16, default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["data_type"], name: "index_import_data_on_data_type"
    t.index ["importable_id", "importable_type"], name: "index_import_data_on_importable_id_and_importable_type"
    t.index ["status"], name: "index_import_data_on_status"
  end

  create_table "permissions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "feature_id"
    t.boolean "can_create", default: false
    t.boolean "can_read", default: true
    t.boolean "can_update", default: false
    t.boolean "can_delete", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["feature_id"], name: "index_permissions_on_feature_id"
    t.index ["user_id", "feature_id"], name: "index_permissions_on_user_id_and_feature_id", unique: true
    t.index ["user_id"], name: "index_permissions_on_user_id"
  end

  create_table "regions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", limit: 128
    t.string "iso_code", limit: 128
    t.integer "country_id"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.integer "priority", default: 1000
    t.boolean "show_in_api", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "operational", default: false
    t.index ["country_id"], name: "index_regions_on_country_id"
    t.index ["iso_code"], name: "index_regions_on_iso_code"
  end

  create_table "registrations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "country_id"
    t.bigint "city_id"
    t.string "dialing_prefix"
    t.string "mobile_number"
    t.string "status", limit: 16, default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_registrations_on_city_id"
    t.index ["country_id"], name: "index_registrations_on_country_id"
    t.index ["user_id"], name: "index_registrations_on_user_id"
  end

  create_table "roles", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_roles_users_on_role_id"
    t.index ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id", unique: true
    t.index ["user_id"], name: "index_roles_users_on_user_id"
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "username", limit: 32, null: false
    t.string "email", null: false
    t.string "phone", limit: 24
    t.string "designation", limit: 56
    t.boolean "super_admin", default: false
    t.string "status", limit: 16, default: "pending", null: false
    t.string "password_digest", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "auth_token"
    t.datetime "token_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "registration_id"
    t.string "gender"
    t.date "date_of_birth"
    t.boolean "dummy", default: false
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["registration_id"], name: "index_users_on_registration_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "users", "registrations"
end
