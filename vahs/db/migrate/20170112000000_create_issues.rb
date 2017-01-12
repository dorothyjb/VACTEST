class CreateIssues < ActiveRecord::Migrations
  def self.up
    create_table "ISSUES", id: false, force: :cascade do |t|
      t.string  "ISSKEY",    limit: 12
      t.integer "ISSSEQ",    limit: 4
      t.string  "ISSPROG",   limit: 6
      t.string  "ISSCODE",   limit: 6
      t.string  "ISSLEV1",   limit: 6
      t.string  "ISSLEV2",   limit: 6
      t.string  "ISSLEV3",   limit: 6
      t.string  "ISSDC",     limit: 1
      t.date    "ISSDCLS"
      t.date    "ISSADTIME"
      t.string  "ISSADUSER", limit: 16
      t.date    "ISSMDTIME"
      t.string  "ISSMDUSER", limit: 16
      t.string  "ISSDESC",   limit: 100
      t.string  "ISSSEL",    limit: 1
      t.string  "ISSGR",     limit: 1
      t.string  "ISSDEV",    limit: 1
    end

    add_index "ISSUES", ["ISSKEY"], name: "fk_isskey", using: :btree
    add_index "ISSUES", ["ISSSEQ"], name: "fk_issseq", using: :btree
  end

  def self.down
    drop_table "ISSUES"
  end
end
