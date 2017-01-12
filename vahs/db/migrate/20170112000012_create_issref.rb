class CreateIssref < ActiveRecord::Migration
  def self.up
    create_table "ISSREF", id: false, force: :cascade do |t|
      t.string "PROG_CODE", limit: 6
      t.string "PROG_DESC", limit: 50
      t.string "ISS_CODE",  limit: 6
      t.string "ISS_DESC",  limit: 50
      t.string "LEV1_CODE", limit: 6
      t.string "LEV1_DESC", limit: 50
      t.string "LEV2_CODE", limit: 6
      t.string "LEV2_DESC", limit: 50
      t.string "LEV3_CODE", limit: 6
      t.string "LEV3_DESC", limit: 50
    end
  end

  def self.down
    drop_table "ISSREF"
  end
end
