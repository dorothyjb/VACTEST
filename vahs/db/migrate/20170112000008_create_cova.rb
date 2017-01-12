class CreateCova < ActiveRecord::Migration
  def self.up
    create_table "COVA", id: false, force: :cascade do |t|
      t.string  "CVFOLDER",    limit: 12
      t.string  "CVDOCKET",    limit: 7
      t.date    "CVDDEC"
      t.string  "CVJOINT",     limit: 1
      t.string  "CVDISP",      limit: 1
      t.string  "CVBM1",       limit: 3
      t.string  "CVBM2",       limit: 3
      t.string  "CVBM3",       limit: 3
      t.string  "CVBM3PLUS",   limit: 1
      t.string  "CVRR",        limit: 26
      t.string  "CVFEDCIR",    limit: 1
      t.string  "CV30DIND",    limit: 1
      t.date    "CV30DATE"
      t.string  "CVLOC",       limit: 1
      t.integer "CVISSSEQ",    limit: 4
      t.date    "CVJUDGEMENT"
      t.date    "CVMANDATE"
      t.string  "CVCOMMENTS",  limit: 2000
      t.string  "CVLITMAT",    limit: 1
      t.string  "CVSTATUS",    limit: 1
      t.string  "CVJMR",       limit: 1
      t.date    "CVJMRDATE"
      t.string  "CVREP",       limit: 1
      t.string  "CVRRTEXT",    limit: 160
    end

    add_index "COVA", ["CVFOLDER"], name: "fk_cvfolder", using: :btree
  end

  def self.down
    drop_table "COVA"
  end
end
