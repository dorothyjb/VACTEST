class CreateRmdrea < ActiveRecord::Migration
  def self.up
   create_table "RMDREA", primary_key: "RMDKEY", force: :cascade do |t|
      t.string  "RMDVAL",      limit: 2
      t.string  "RMDMDUSR",    limit: 16
      t.date    "RMDMDTIM"
      t.string  "RMDPRIORITY", limit: 2
      t.integer "RMDISSSEQ",   limit: 4
      t.string  "RMDDEV",      limit: 2
    end
  end

  def self.down
    drop_table "RMDREA"
  end
end
