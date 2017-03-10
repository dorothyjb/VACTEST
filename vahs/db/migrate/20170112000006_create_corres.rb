class CreateCorres < ActiveRecord::Migration
  def self.up
    create_table "CORRES", primary_key: "STAFKEY", force: :cascade do |t|
      t.string  "SUSRPW",    limit: 16
      t.string  "SUSRSEC",   limit: 5
      t.string  "SUSRTYP",   limit: 10
      t.string  "SSALUT",    limit: 15
      t.string  "SNAMEF",    limit: 24
      t.string  "SNAMEMI",   limit: 4
      t.string  "SNAMEL",    limit: 60
      t.string  "SLOGID",    limit: 16
      t.string  "STITLE",    limit: 40
      t.string  "SORG",      limit: 50
      t.string  "SDEPT",     limit: 50
      t.string  "SADDRNUM",  limit: 10
      t.string  "SADDRST1",  limit: 60
      t.string  "SADDRST2",  limit: 60
      t.string  "SADDRCTY",  limit: 20
      t.string  "SADDRSTT",  limit: 4
      t.string  "SADDRCNTY", limit: 6
      t.string  "SADDRZIP",  limit: 10
      t.string  "STELW",     limit: 20
      t.string  "STELWEX",   limit: 20
      t.string  "STELFAX",   limit: 20
      t.string  "STELH",     limit: 20
      t.string  "STADUSER",  limit: 16
      t.date    "STADTIME"
      t.string  "STMDUSER",  limit: 16
      t.date    "STMDTIME"
      t.integer "STC1",      limit: 4
      t.integer "STC2",      limit: 4
      t.integer "STC3",      limit: 4
      t.integer "STC4",      limit: 4
      t.string  "SNOTES",    limit: 80
      t.integer "SORC1",     limit: 4
      t.integer "SORC2",     limit: 4
      t.integer "SORC3",     limit: 4
      t.integer "SORC4",     limit: 4
      t.string  "SACTIVE",   limit: 1
      t.string  "SSYS",      limit: 16
      t.string  "SSPARE1",   limit: 20
      t.string  "SSPARE2",   limit: 20
      t.string  "SSPARE3",   limit: 20
      t.string  "SSPARE4",   limit: 10
      t.string  "SSN",       limit: 9
      t.date    "SFNOD"
      t.date    "SDOB"
      t.string  "SGENDER",   limit: 1
    end

    add_index "CORRES", ["STAFKEY"], name: "STAFKEY", unique: true, using: :btree
  end

  def self.down
    drop_table "CORRES"
  end
end
