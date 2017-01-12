class CreateActCode < ActiveRecord::Migration
  def self.up
    create_table "ACTCODE", primary_key: "ACTCKEY", force: :cascade do |t|
      t.string "ACTCDESC",  limit: 50
      t.string "ACTCSEC",   limit: 5
      t.string "ACTCUKEY",  limit: 10
      t.string "ACTCDTC",   limit: 3
      t.string "ACTADUSR",  limit: 16
      t.date   "ACTADTIM"
      t.string "ACTMDUSR",  limit: 16
      t.date   "ACTMDTIM"
      t.string "ACACTIVE",  limit: 1
      t.string "ACTSYS",    limit: 16
      t.string "ACTCDESC2", limit: 280
      t.string "ACSPARE1",  limit: 20
      t.string "ACSPARE2",  limit: 20
      t.string "ACSPARE3",  limit: 20
    end
  end

  def self.down
    drop_table "ACTCODE"
  end
end
