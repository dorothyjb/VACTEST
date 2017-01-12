class CreateOthDocs < ActiveRecord::Migration
  def self.up
    create_table "OTHDOCS", id: false, force: :cascade do |t|
      t.string "TICKNUM",  limit: 12
      t.string "CLMFLD",   limit: 3
      t.string "INCLMFLD", limit: 3
      t.string "XRAY",     limit: 3
      t.string "SLIDES",   limit: 3
      t.string "TISBLK",   limit: 3
      t.string "VREFLD",   limit: 3
      t.string "WOEFLD",   limit: 3
      t.string "OEFLD",    limit: 3
      t.string "CNSLTRN",  limit: 3
      t.string "LNGRN",    limit: 3
      t.string "INSFLD",   limit: 3
      t.string "DNLFLD",   limit: 3
      t.string "OUTTRT",   limit: 3
      t.string "CLINICAL", limit: 3
      t.string "HSPCOR",   limit: 3
      t.string "GRDSHP",   limit: 3
      t.string "INVFLD",   limit: 3
      t.string "OTHMED",   limit: 3
      t.string "OTHLEG",   limit: 3
      t.string "OTHER",    limit: 3
      t.string "SDRENV",   limit: 3
      t.string "OTHDESC",  limit: 30
      t.string "COPAY",    limit: 3
    end

    add_index "OTHDOCS", ["TICKNUM"], name: "fk_ticknum", using: :btree
  end

  def self.down
    drop_table "OTHDOCS"
  end
end
