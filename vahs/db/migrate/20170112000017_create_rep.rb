class CreateRep < ActiveRecord::Migration
  def self.up
    create_table "REP", id: false, force: :cascade do |t|
      t.string "REPKEY",     limit: 12
      t.date   "REPADDTIME"
      t.string "REPTYPE",    limit: 1
      t.string "REPSO",      limit: 1
      t.string "REPLAST",    limit: 40
      t.string "REPFIRST",   limit: 24
      t.string "REPMI",      limit: 4
      t.string "REPSUF",     limit: 4
      t.string "REPADDR1",   limit: 50
      t.string "REPADDR2",   limit: 50
      t.string "REPCITY",    limit: 20
      t.string "REPST",      limit: 4
      t.string "REPZIP",     limit: 10
      t.string "REPPHONE",   limit: 20
      t.string "REPNOTES",   limit: 50
      t.string "REPMODUSER", limit: 16
      t.date   "REPMODTIME"
      t.string "REPDIRPAY",  limit: 1
      t.date   "REPDFEE"
      t.date   "REPFEERECV"
      t.date   "REPLASTDOC"
      t.date   "REPFEEDISP"
      t.string "REPCORKEY",  limit: 16
      t.date   "REPACKNW"
    end
  end

  def self.down
    drop_table "REP"
  end
end
