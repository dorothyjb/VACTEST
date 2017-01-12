class CreateVFTypes < ActiveRecord::Migration
  def self.up
    create_table "VFTYPES", id: false, force: :cascade do |t|
      t.string "FTKEY",    limit: 10
      t.string "FTDESC",   limit: 100
      t.string "FTADUSR",  limit: 16
      t.date   "FTADTIM"
      t.string "FTMDUSR",  limit: 16
      t.date   "FTMDTIM"
      t.string "FTACTIVE", limit: 1
      t.string "FTTYPE",   limit: 16
      t.string "FTSYS",    limit: 16
      t.string "FTSPARE1", limit: 20
      t.string "FTSPARE2", limit: 20
      t.string "FTSPARE3", limit: 20
    end
  end

  def self.down
    drop_table "VFTYPES"
  end
end
