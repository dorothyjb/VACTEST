class CreateCorrtyps < ActiveRecord::Migration
  def self.up
    create_table "CORRTYPS", primary_key: "CTYPKEY", force: :cascade do |t|
      t.string "CTYPVAL",  limit: 10
      t.string "CTYADUSR", limit: 16
      t.date   "CTYADTIM"
      t.string "CTYMDUSR", limit: 16
      t.date   "CTYMDTIM"
      t.string "CTYACTVE", limit: 1
      t.string "CTYSYS",   limit: 16
    end
  end

  def self.down
    drop_table "CORRTYPS"
  end
end
