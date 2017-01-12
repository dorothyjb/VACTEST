class CreateMail < ActiveRecord::Migrations
  def self.up
    create_table "MAIL", id: false, force: :cascade do |t|
      t.string  "MLFOLDER",   limit: 12
      t.integer "MLSEQ",      limit: 4
      t.string  "MLCORKEY",   limit: 16
      t.string  "MLSOURCE",   limit: 1
      t.string  "MLTYPE",     limit: 2
      t.date    "MLCORRDATE"
      t.date    "MLRECVDATE"
      t.date    "MLDUEDATE"
      t.date    "MLCOMPDATE"
      t.string  "MLACTION",   limit: 2
      t.string  "MLASSIGNEE", limit: 16
      t.string  "MLNOTES",    limit: 80
      t.string  "MLADDUSER",  limit: 16
      t.date    "MLADDTIME"
      t.string  "MLMODUSER",  limit: 16
      t.date    "MLMODTIME"
      t.string  "MLCONTROL",  limit: 1
      t.string  "MLEDMS",     limit: 10
      t.date    "MLACTDATE"
      t.string  "MLREQLAST",  limit: 25
      t.string  "MLREQFIRST", limit: 15
      t.string  "MLREQMI",    limit: 1
      t.string  "MLREQREL",   limit: 1
      t.string  "MLACCESS",   limit: 1
      t.string  "MLAMEND",    limit: 1
      t.string  "MLLIT",      limit: 1
      t.float   "MLFEE",      limit: 24
      t.integer "MLPAGES",    limit: 4
      t.string  "MLADDR1",    limit: 40
      t.string  "MLADDR2",    limit: 40
      t.string  "MLCITY",     limit: 20
      t.string  "MLST",       limit: 4
      t.string  "MLZIP",      limit: 10
      t.date    "MLFOIADATE"
      t.string  "MLREQFAC",   limit: 25
      t.string  "MLTRACK",    limit: 1
      t.date    "MLDUE2ND"
      t.string  "MLAUTH",     limit: 1
    end

    add_index "MAIL", ["MLFOLDER"], name: "fk_mlfolder", using: :btree
  end

  def self.down
    drop_table "MAIL"
  end
end
