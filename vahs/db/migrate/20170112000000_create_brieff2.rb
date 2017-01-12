class CreateBrieff2 < ActiveRecord::Migration
  def self.up
    create_table "BRIEFF_2", id: false, force: :cascade do |t|
      t.string "BFKEY",      limit: 12, null: false
      t.date   "BFDDEC"
      t.string "BFCORKEY",   limit: 16
      t.string "BFCORLID",   limit: 16
      t.string "BFDCN",      limit: 6
      t.string "BFDOCIND",   limit: 1
      t.string "BFPDNUM",    limit: 12
      t.date   "BFDPDCN"
      t.string "BFORGTIC",   limit: 12
      t.date   "BFDORG"
      t.date   "BFDTHURB"
      t.date   "BFDNOD"
      t.date   "BFDSOC"
      t.date   "BFD19"
      t.date   "BF41STAT"
      t.string "BFMSTAT",    limit: 1
      t.string "BFMPRO",     limit: 3
      t.date   "BFDMCON"
      t.string "BFREGOFF",   limit: 16
      t.string "BFISSNR",    limit: 1
      t.string "BFRDMREF",   limit: 1
      t.string "BFCASEV",    limit: 4
      t.string "BFCASEVA",   limit: 4
      t.string "BFCASEVB",   limit: 4
      t.string "BFCASEVC",   limit: 4
      t.string "BFBOARD",    limit: 10
      t.date   "BFBSASGN"
      t.string "BFATTID",    limit: 16
      t.date   "BFDASGN"
      t.string "BFCCLKID",   limit: 16
      t.date   "BFDQRSNT"
      t.date   "BFDLOCIN"
      t.date   "BFDLOOUT"
      t.string "BFSTASGN",   limit: 16
      t.string "BFCURLOC",   limit: 10
      t.string "BFNRCOPY",   limit: 4
      t.string "BFMEMID",    limit: 16
      t.date   "BFDMEM"
      t.string "BFNRCI",     limit: 5
      t.string "BFCALLUP",   limit: 1
      t.string "BFCALLYYMM", limit: 4
      t.string "BFHINES",    limit: 2
      t.string "BFDCFLD1",   limit: 2
      t.string "BFDCFLD2",   limit: 2
      t.string "BFDCFLD3",   limit: 2
      t.string "BFAC",       limit: 1
      t.string "BFDC",       limit: 1
      t.string "BFHA",       limit: 1
      t.string "BFIC",       limit: 2
      t.string "BFIO",       limit: 2
      t.string "BFMS",       limit: 1
      t.string "BFOC",       limit: 1
      t.string "BFSH",       limit: 1
      t.string "BFSO",       limit: 1
      t.string "BFHR",       limit: 1
      t.string "BFST",       limit: 1
      t.date   "BFDRODEC"
      t.date   "BFSSOC1"
      t.date   "BFSSOC2"
      t.date   "BFSSOC3"
      t.date   "BFSSOC4"
      t.date   "BFSSOC5"
      t.date   "BFDTB"
      t.string "BFTBIND",    limit: 1
      t.date   "BFDCUE"
      t.date   "BFDVIN"
      t.date   "BFDVOUT"
      t.date   "BFDDRO"
      t.string "BFDROID",    limit: 3
      t.date   "BFDDVWRK"
      t.date   "BFDDVDSP"
      t.date   "BFDDVRET"
      t.string "BFDRORTR",   limit: 1
      t.string "BFRO1",      limit: 4
      t.string "BFLOT",      limit: 2
      t.string "BFBOX",      limit: 4
      t.date   "BFDTBREADY"
      t.string "BFARC",      limit: 4
      t.date   "BFDARCIN"
      t.date   "BFDARCOUT"
      t.string "BFARCDISP",  limit: 1
      t.string "BFSUB",      limit: 1
      t.string "BFROCDOC",   limit: 1
      t.date   "BFDROCKET"
      t.date   "BFDCERTOOL"
    end
  end

  def self.down
    drop_table "BRIEFF_2"
  end
end
