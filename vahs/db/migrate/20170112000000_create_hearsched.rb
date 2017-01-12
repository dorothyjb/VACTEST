class CreateHearSched < ActiveRecord::Migration
  def self.up
    create_table "HEARSCHED", id: false, force: :cascade do |t|
      t.integer "HEARING_PKSEQ", limit: 4
      t.string  "HEARING_TYPE",  limit: 1
      t.string  "FOLDER_NR",     limit: 12
      t.date    "HEARING_DATE"
      t.string  "HEARING_DISP",  limit: 1
      t.string  "BOARD_MEMBER",  limit: 20
      t.string  "NOTES1",        limit: 100
      t.string  "TEAM",          limit: 2
      t.string  "ROOM",          limit: 4
      t.string  "REP_STATE",     limit: 2
      t.string  "MDUSER",        limit: 16
      t.date    "MDTIME"
      t.date    "REQDATE"
      t.date    "CLSDATE"
      t.string  "RECMED",        limit: 1
      t.date    "CONSENT"
      t.date    "CONRET"
      t.string  "CONTAPES",      limit: 1
      t.string  "TRANREQ",       limit: 1
      t.date    "TRANSENT"
      t.integer "WBTAPES",       limit: 4
      t.string  "WBBACKUP",      limit: 1
      t.date    "WBSENT"
      t.string  "RECPROB",       limit: 1
      t.string  "TASKNO",        limit: 7
      t.string  "ADDUSER",       limit: 16
      t.date    "ADDTIME"
      t.string  "AOD",           limit: 1
      t.integer "HOLDAYS",       limit: 4
      t.string  "VDKEY",         limit: 12
      t.string  "REPNAME",       limit: 25
      t.string  "VDBVAPOC",      limit: 30
      t.string  "VDROPOC",       limit: 30
      t.date    "CANCELDATE"
    end

    add_index "HEARSCHED", ["FOLDER_NR"], name: "fk_folder_nr", using: :btree
  end

  def self.down
    drop_table "HEARSCHED"
  end
end
