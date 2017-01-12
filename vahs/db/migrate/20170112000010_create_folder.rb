class CreateFolder < ActiveRecord::Migration
  def self.up
    create_table "FOLDER", id: false, force: :cascade do |t|
      t.string "TICKNUM",     limit: 12
      t.string "TICORKEY",    limit: 16
      t.string "TISTKEY",     limit: 16
      t.string "TINUM",       limit: 20
      t.string "TIFILOC",     limit: 20
      t.string "TIADDRTO",    limit: 10
      t.string "TITRNUM",     limit: 20
      t.string "TICUKEY",     limit: 10
      t.date   "TIDSNT"
      t.date   "TIDRECV"
      t.date   "TIDDUE"
      t.date   "TIDCLS"
      t.string "TIWPPTR",     limit: 250
      t.string "TIWPPTRT",    limit: 2
      t.string "TIADUSER",    limit: 16
      t.date   "TIADTIME"
      t.string "TIMDUSER",    limit: 16
      t.date   "TIMDTIME"
      t.date   "TICLSTME"
      t.string "TIRESP1",     limit: 5
      t.string "TIKEYWRD",    limit: 250
      t.string "TIACTIVE",    limit: 1
      t.string "TISPARE1",    limit: 30
      t.string "TISPARE2",    limit: 20
      t.string "TISPARE3",    limit: 30
      t.string "TIREAD1",     limit: 28
      t.string "TIREAD2",     limit: 16
      t.string "TIMT",        limit: 10
      t.string "TISUBJ1",     limit: 1
      t.string "TISUBJ",      limit: 1
      t.string "TISUBJ2",     limit: 1
      t.string "TISYS",       limit: 16
      t.string "TIAGOR",      limit: 1
      t.string "TIASBT",      limit: 1
      t.string "TIGWUI",      limit: 1
      t.string "TIHEPC",      limit: 1
      t.string "TIAIDS",      limit: 1
      t.string "TIMGAS",      limit: 1
      t.string "TIPTSD",      limit: 1
      t.string "TIRADB",      limit: 1
      t.string "TIRADN",      limit: 1
      t.string "TISARC",      limit: 1
      t.string "TISEXH",      limit: 1
      t.string "TITOBA",      limit: 1
      t.string "TINOSC",      limit: 1
      t.string "TI38US",      limit: 1
      t.string "TINNME",      limit: 1
      t.string "TINWGR",      limit: 1
      t.string "TIPRES",      limit: 1
      t.string "TITRTM",      limit: 1
      t.string "TINOOT",      limit: 1
      t.date   "TIOCTIME"
      t.string "TIOCUSER",    limit: 16
      t.date   "TIDKTIME"
      t.string "TIDKUSER",    limit: 16
      t.date   "TIPULAC"
      t.date   "TICERULLO"
      t.string "TIPLNOD",     limit: 1
      t.string "TIPLWAIVER",  limit: 1
      t.string "TIPLEXPRESS", limit: 1
      t.string "TISNL",       limit: 1
      t.string "TIVBMS",      limit: 1
    end

    add_index "FOLDER", ["TICKNUM"], name: "fk_ticknum", using: :btree
    add_index "FOLDER", ["TICORKEY"], name: "fk_ticorkey", using: :btree
  end

  def self.down
    drop_table "FOLDER"
  end
end
