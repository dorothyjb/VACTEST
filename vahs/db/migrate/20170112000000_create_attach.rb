class CreateAttach < ActiveRecord::Migration
  def self.up
    create_table "ATTACH", primary_key: "IMGKEY", force: :cascade do |t|
      t.string "IMGTKKY",  limit: 12
      t.string "IMGTSKKY", limit: 12
      t.string "IMGDOC",   limit: 96
      t.string "IMGDOCTP", limit: 4
      t.string "IMGDESC",  limit: 70
      t.string "IMGLOC",   limit: 150
      t.string "IMGCLASS", limit: 10
      t.string "IMGOWNER", limit: 16
      t.string "IMGADUSR", limit: 16
      t.date   "IMGADTM"
      t.string "IMGMDUSR", limit: 16
      t.date   "IMGMDTM"
      t.string "IMACTIVE", limit: 1
      t.string "IMSPARE1", limit: 30
      t.string "IMSPARE2", limit: 30
      t.string "IMREAD1",  limit: 28
      t.string "IMREAD2",  limit: 16
      t.string "IMGSYS",   limit: 16
    end
  end

  def self.down
    drop_table "ATTACH"
  end
end
