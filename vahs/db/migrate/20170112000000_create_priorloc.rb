class CreatePriorLoc < ActiveRecord::Migration
  def self.up
    create_table "PRIORLOC", id: false, force: :cascade do |t|
      t.string "LOCLCODE", limit: 10
      t.string "LOCKEY",   limit: 12
      t.date   "LOCDIN"
      t.date   "LOCDOUT"
      t.string "LOCSTTO",  limit: 16
      t.string "LOCSTRCV", limit: 16
      t.string "LOCSTOUT", limit: 16
      t.string "LOCEXCEP", limit: 10
      t.date   "LOCDTO"
    end

    add_index "PRIORLOC", ["LOCKEY"], name: "fk_lockey", using: :btree
  end

  def self.down
    drop_table "PRIORLOC"
  end 
end
