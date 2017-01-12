class CreateCoin < ActiveRecord::Migration
  def self.up
    create_table "COIN", id: false, force: :cascade do |t|
      t.string  "COINRO",    limit: 4
      t.date    "RPTDT"
      t.integer "NODCM",     limit: 4
      t.integer "NODFY",     limit: 4
      t.integer "NODPNCM",   limit: 4
      t.integer "DNODPNCM",  limit: 4
      t.integer "SOCCM",     limit: 4
      t.integer "SOCFY",     limit: 4
      t.integer "DSOCCM",    limit: 4
      t.integer "DSOCFY",    limit: 4
      t.integer "F9CM",      limit: 4
      t.integer "F9FY",      limit: 4
      t.integer "DF9CM",     limit: 4
      t.integer "DF9FY",     limit: 4
      t.integer "F9WOSSOC",  limit: 4
      t.integer "F9WSSOC",   limit: 4
      t.integer "DF9WOSSOC", limit: 4
      t.integer "DF9WSSOC",  limit: 4
      t.integer "SSOCCM",    limit: 4
      t.integer "SSOCFY",    limit: 4
      t.integer "DSSOCCM",   limit: 4
      t.integer "DSSOCFY",   limit: 4
      t.integer "CERTCM",    limit: 4
      t.integer "CERTFY",    limit: 4
      t.integer "DCERTCM",   limit: 4
      t.integer "DCERTFY",   limit: 4
    end
  end

  def self.down
    drop_table "COIN"
  end
end
