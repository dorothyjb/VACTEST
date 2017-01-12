class CreateDecreview < ActiveRecord::Migration
  def self.up
    create_table "DECREVIEW", primary_key: "FOLDER", force: :cascade do |t|
      t.string "APPEAL_ID",   limit: 10
      t.date   "REVIEW_DATE"
      t.string "ISSUE",       limit: 5
      t.string "DIFFICULTY",  limit: 1
      t.string "USER_ID",     limit: 11
      t.string "EX1",         limit: 5
      t.string "EX2",         limit: 5
      t.string "EX3",         limit: 5
      t.string "EX4",         limit: 5
      t.string "EX5",         limit: 5
      t.string "EX6",         limit: 5
      t.string "EX7",         limit: 5
      t.string "EX8",         limit: 5
      t.string "EX9",         limit: 5
      t.string "EX10",        limit: 5
      t.string "EX11",        limit: 5
      t.string "EX12",        limit: 5
      t.string "EX13",        limit: 5
      t.string "EX14",        limit: 5
      t.string "EX15",        limit: 5
      t.string "EX16",        limit: 5
      t.string "EX17",        limit: 5
      t.string "EX18",        limit: 5
      t.string "EX19",        limit: 5
      t.string "EX20",        limit: 5
      t.string "EX21",        limit: 5
      t.string "EX22",        limit: 5
      t.string "EX23",        limit: 5
      t.string "EX24",        limit: 5
      t.string "EX25",        limit: 5
      t.string "EX26",        limit: 5
      t.string "EX27",        limit: 5
      t.string "EX28",        limit: 5
      t.string "EX29",        limit: 5
      t.string "EX30",        limit: 5
      t.string "EX31",        limit: 5
      t.string "EX32",        limit: 5
      t.string "EX33",        limit: 5
      t.string "EX34",        limit: 5
      t.string "EX35",        limit: 5
      t.string "EX36",        limit: 5
      t.string "EX37",        limit: 5
      t.string "EX38",        limit: 5
      t.string "DECTYPE",     limit: 1
      t.string "RECFORMAT",   limit: 3
      t.string "MODUSER",     limit: 16
      t.date   "MODTIME"
    end
  end

  def self.down
    drop_table "DECREVIEW"
  end
end
