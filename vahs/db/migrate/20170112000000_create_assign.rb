class CreateAssign < ActiveRecord::Migration
  def self.up
    create_table "ASSIGN", primary_key: "TASKNUM", force: :cascade do |t|
      t.string  "TSKTKNM",  limit: 12
      t.string  "TSKSTFAS", limit: 16
      t.string  "TSKACTCD", limit: 10
      t.string  "TSKCLASS", limit: 10
      t.string  "TSKRQACT", limit: 10
      t.string  "TSKRSPN",  limit: 280
      t.date    "TSKDASSN"
      t.integer "TSKDTC",   limit: 4
      t.date    "TSKDDUE"
      t.date    "TSKDCLS"
      t.string  "TSKSTOWN", limit: 16
      t.string  "TSKSTAT",  limit: 1
      t.string  "TSKOWNTS", limit: 12
      t.date    "TSKCLSTM"
      t.string  "TSKADUSR", limit: 16
      t.date    "TSKADTM"
      t.string  "TSKMDUSR", limit: 16
      t.date    "TSKMDTM"
      t.string  "TSACTIVE", limit: 1
      t.string  "TSSPARE1", limit: 30
      t.string  "TSSPARE2", limit: 30
      t.string  "TSSPARE3", limit: 30
      t.string  "TSREAD1",  limit: 28
      t.string  "TSREAD",   limit: 16
      t.string  "TSKORDER", limit: 15
      t.string  "TSSYS",    limit: 16
    end
  end

  def self.down
    drop_table "ASSIGN"
  end
end
