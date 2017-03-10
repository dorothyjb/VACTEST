# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170112000020) do

  create_table "ACTCODE", primary_key: "ACTCKEY", force: :cascade do |t|
    t.string "ACTCDESC",  limit: 50
    t.string "ACTCSEC",   limit: 5
    t.string "ACTCUKEY",  limit: 10
    t.string "ACTCDTC",   limit: 3
    t.string "ACTADUSR",  limit: 16
    t.date   "ACTADTIM"
    t.string "ACTMDUSR",  limit: 16
    t.date   "ACTMDTIM"
    t.string "ACACTIVE",  limit: 1
    t.string "ACTSYS",    limit: 16
    t.string "ACTCDESC2", limit: 280
    t.string "ACSPARE1",  limit: 20
    t.string "ACSPARE2",  limit: 20
    t.string "ACSPARE3",  limit: 20
  end

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

  add_index "ASSIGN", ["TSKTKNM"], name: "fk_tsktknm", using: :btree

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

  add_index "ATTACH", ["IMGTKKY"], name: "fk_imgtkky", using: :btree

  create_table "BRIEFF", primary_key: "BFKEY", force: :cascade do |t|
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

  add_index "BRIEFF", ["BFCORKEY"], name: "fk_corkey", using: :btree

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

  create_table "CORRES", primary_key: "STAFKEY", force: :cascade do |t|
    t.string  "SUSRPW",    limit: 16
    t.string  "SUSRSEC",   limit: 5
    t.string  "SUSRTYP",   limit: 10
    t.string  "SSALUT",    limit: 15
    t.string  "SNAMEF",    limit: 24
    t.string  "SNAMEMI",   limit: 4
    t.string  "SNAMEL",    limit: 60
    t.string  "SLOGID",    limit: 16
    t.string  "STITLE",    limit: 40
    t.string  "SORG",      limit: 50
    t.string  "SDEPT",     limit: 50
    t.string  "SADDRNUM",  limit: 10
    t.string  "SADDRST1",  limit: 60
    t.string  "SADDRST2",  limit: 60
    t.string  "SADDRCTY",  limit: 20
    t.string  "SADDRSTT",  limit: 4
    t.string  "SADDRCNTY", limit: 6
    t.string  "SADDRZIP",  limit: 10
    t.string  "STELW",     limit: 20
    t.string  "STELWEX",   limit: 20
    t.string  "STELFAX",   limit: 20
    t.string  "STELH",     limit: 20
    t.string  "STADUSER",  limit: 16
    t.date    "STADTIME"
    t.string  "STMDUSER",  limit: 16
    t.date    "STMDTIME"
    t.integer "STC1",      limit: 4
    t.integer "STC2",      limit: 4
    t.integer "STC3",      limit: 4
    t.integer "STC4",      limit: 4
    t.string  "SNOTES",    limit: 80
    t.integer "SORC1",     limit: 4
    t.integer "SORC2",     limit: 4
    t.integer "SORC3",     limit: 4
    t.integer "SORC4",     limit: 4
    t.string  "SACTIVE",   limit: 1
    t.string  "SSYS",      limit: 16
    t.string  "SSPARE1",   limit: 20
    t.string  "SSPARE2",   limit: 20
    t.string  "SSPARE3",   limit: 20
    t.string  "SSPARE4",   limit: 10
    t.string  "SSN",       limit: 9
    t.date    "SFNOD"
    t.date    "SDOB"
    t.string  "SGENDER",   limit: 1
  end

  add_index "CORRES", ["STAFKEY"], name: "STAFKEY", unique: true, using: :btree

  create_table "CORRTYPS", primary_key: "CTYPKEY", force: :cascade do |t|
    t.string "CTYPVAL",  limit: 10
    t.string "CTYADUSR", limit: 16
    t.date   "CTYADTIM"
    t.string "CTYMDUSR", limit: 16
    t.date   "CTYMDTIM"
    t.string "CTYACTVE", limit: 1
    t.string "CTYSYS",   limit: 16
  end

  create_table "COVA", id: false, force: :cascade do |t|
    t.string  "CVFOLDER",    limit: 12
    t.string  "CVDOCKET",    limit: 7
    t.date    "CVDDEC"
    t.string  "CVJOINT",     limit: 1
    t.string  "CVDISP",      limit: 1
    t.string  "CVBM1",       limit: 3
    t.string  "CVBM2",       limit: 3
    t.string  "CVBM3",       limit: 3
    t.string  "CVBM3PLUS",   limit: 1
    t.string  "CVRR",        limit: 26
    t.string  "CVFEDCIR",    limit: 1
    t.string  "CV30DIND",    limit: 1
    t.date    "CV30DATE"
    t.string  "CVLOC",       limit: 1
    t.integer "CVISSSEQ",    limit: 4
    t.date    "CVJUDGEMENT"
    t.date    "CVMANDATE"
    t.string  "CVCOMMENTS",  limit: 2000
    t.string  "CVLITMAT",    limit: 1
    t.string  "CVSTATUS",    limit: 1
    t.string  "CVJMR",       limit: 1
    t.date    "CVJMRDATE"
    t.string  "CVREP",       limit: 1
    t.string  "CVRRTEXT",    limit: 160
  end

  add_index "COVA", ["CVFOLDER"], name: "fk_cvfolder", using: :btree

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

  create_table "FOLDER", id: false, force: :cascade do |t|
    t.string "TICKNUM",     limit: 12
    t.string "TICORKEY",    limit: 16
    t.string "TISTKEY",     limit: 16
    t.string "TINUM",       limit: 20
    t.string "TIFILOC",     limit: 20
    t.string "TIADDRTO",    limit: 10
    t.string "TITRNUM",     limit: 20
    t.string "TICUKEY",     limit: 10
    t.date   "TIDSNT"
    t.date   "TIDRECV"
    t.date   "TIDDUE"
    t.date   "TIDCLS"
    t.string "TIWPPTR",     limit: 250
    t.string "TIWPPTRT",    limit: 2
    t.string "TIADUSER",    limit: 16
    t.date   "TIADTIME"
    t.string "TIMDUSER",    limit: 16
    t.date   "TIMDTIME"
    t.date   "TICLSTME"
    t.string "TIRESP1",     limit: 5
    t.string "TIKEYWRD",    limit: 250
    t.string "TIACTIVE",    limit: 1
    t.string "TISPARE1",    limit: 30
    t.string "TISPARE2",    limit: 20
    t.string "TISPARE3",    limit: 30
    t.string "TIREAD1",     limit: 28
    t.string "TIREAD2",     limit: 16
    t.string "TIMT",        limit: 10
    t.string "TISUBJ1",     limit: 1
    t.string "TISUBJ",      limit: 1
    t.string "TISUBJ2",     limit: 1
    t.string "TISYS",       limit: 16
    t.string "TIAGOR",      limit: 1
    t.string "TIASBT",      limit: 1
    t.string "TIGWUI",      limit: 1
    t.string "TIHEPC",      limit: 1
    t.string "TIAIDS",      limit: 1
    t.string "TIMGAS",      limit: 1
    t.string "TIPTSD",      limit: 1
    t.string "TIRADB",      limit: 1
    t.string "TIRADN",      limit: 1
    t.string "TISARC",      limit: 1
    t.string "TISEXH",      limit: 1
    t.string "TITOBA",      limit: 1
    t.string "TINOSC",      limit: 1
    t.string "TI38US",      limit: 1
    t.string "TINNME",      limit: 1
    t.string "TINWGR",      limit: 1
    t.string "TIPRES",      limit: 1
    t.string "TITRTM",      limit: 1
    t.string "TINOOT",      limit: 1
    t.date   "TIOCTIME"
    t.string "TIOCUSER",    limit: 16
    t.date   "TIDKTIME"
    t.string "TIDKUSER",    limit: 16
    t.date   "TIPULAC"
    t.date   "TICERULLO"
    t.string "TIPLNOD",     limit: 1
    t.string "TIPLWAIVER",  limit: 1
    t.string "TIPLEXPRESS", limit: 1
    t.string "TISNL",       limit: 1
    t.string "TIVBMS",      limit: 1
  end

  add_index "FOLDER", ["TICKNUM"], name: "fk_ticknum", using: :btree
  add_index "FOLDER", ["TICORKEY"], name: "fk_ticorkey", using: :btree

  create_table "HEARSCHED", id: false, force: :cascade do |t|
    t.integer "HEARING_PKSEQ", limit: 4
    t.string  "HEARING_TYPE",  limit: 1
    t.string  "FOLDER_NR",     limit: 12
    t.date    "HEARING_DATE"
    t.string  "HEARING_DISP",  limit: 1
    t.string  "BOARD_MEMBER",  limit: 20
    t.string  "NOTES1",        limit: 100
    t.string  "TEAM",          limit: 2
    t.string  "ROOM",          limit: 4
    t.string  "REP_STATE",     limit: 2
    t.string  "MDUSER",        limit: 16
    t.date    "MDTIME"
    t.date    "REQDATE"
    t.date    "CLSDATE"
    t.string  "RECMED",        limit: 1
    t.date    "CONSENT"
    t.date    "CONRET"
    t.string  "CONTAPES",      limit: 1
    t.string  "TRANREQ",       limit: 1
    t.date    "TRANSENT"
    t.integer "WBTAPES",       limit: 4
    t.string  "WBBACKUP",      limit: 1
    t.date    "WBSENT"
    t.string  "RECPROB",       limit: 1
    t.string  "TASKNO",        limit: 7
    t.string  "ADDUSER",       limit: 16
    t.date    "ADDTIME"
    t.string  "AOD",           limit: 1
    t.integer "HOLDAYS",       limit: 4
    t.string  "VDKEY",         limit: 12
    t.string  "REPNAME",       limit: 25
    t.string  "VDBVAPOC",      limit: 30
    t.string  "VDROPOC",       limit: 30
    t.date    "CANCELDATE"
  end

  add_index "HEARSCHED", ["FOLDER_NR"], name: "fk_folder_nr", using: :btree

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

  create_table "MAIL", id: false, force: :cascade do |t|
    t.string  "MLFOLDER",   limit: 12
    t.integer "MLSEQ",      limit: 4
    t.string  "MLCORKEY",   limit: 16
    t.string  "MLSOURCE",   limit: 1
    t.string  "MLTYPE",     limit: 2
    t.date    "MLCORRDATE"
    t.date    "MLRECVDATE"
    t.date    "MLDUEDATE"
    t.date    "MLCOMPDATE"
    t.string  "MLACTION",   limit: 2
    t.string  "MLASSIGNEE", limit: 16
    t.string  "MLNOTES",    limit: 80
    t.string  "MLADDUSER",  limit: 16
    t.date    "MLADDTIME"
    t.string  "MLMODUSER",  limit: 16
    t.date    "MLMODTIME"
    t.string  "MLCONTROL",  limit: 1
    t.string  "MLEDMS",     limit: 10
    t.date    "MLACTDATE"
    t.string  "MLREQLAST",  limit: 25
    t.string  "MLREQFIRST", limit: 15
    t.string  "MLREQMI",    limit: 1
    t.string  "MLREQREL",   limit: 1
    t.string  "MLACCESS",   limit: 1
    t.string  "MLAMEND",    limit: 1
    t.string  "MLLIT",      limit: 1
    t.float   "MLFEE",      limit: 24
    t.integer "MLPAGES",    limit: 4
    t.string  "MLADDR1",    limit: 40
    t.string  "MLADDR2",    limit: 40
    t.string  "MLCITY",     limit: 20
    t.string  "MLST",       limit: 4
    t.string  "MLZIP",      limit: 10
    t.date    "MLFOIADATE"
    t.string  "MLREQFAC",   limit: 25
    t.string  "MLTRACK",    limit: 1
    t.date    "MLDUE2ND"
    t.string  "MLAUTH",     limit: 1
  end

  add_index "MAIL", ["MLFOLDER"], name: "fk_mlfolder", using: :btree

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

  create_table "PRIORLOC", id: false, force: :cascade do |t|
    t.string "LOCLCODE", limit: 10
    t.string "LOCKEY",   limit: 12
    t.date   "LOCDIN"
    t.date   "LOCDOUT"
    t.string "LOCSTTO",  limit: 16
    t.string "LOCSTRCV", limit: 16
    t.string "LOCSTOUT", limit: 16
    t.string "LOCEXCEP", limit: 10
    t.date   "LOCDTO"
  end

  add_index "PRIORLOC", ["LOCKEY"], name: "fk_lockey", using: :btree

  create_table "REP", id: false, force: :cascade do |t|
    t.string "REPKEY",     limit: 12
    t.date   "REPADDTIME"
    t.string "REPTYPE",    limit: 1
    t.string "REPSO",      limit: 1
    t.string "REPLAST",    limit: 40
    t.string "REPFIRST",   limit: 24
    t.string "REPMI",      limit: 4
    t.string "REPSUF",     limit: 4
    t.string "REPADDR1",   limit: 50
    t.string "REPADDR2",   limit: 50
    t.string "REPCITY",    limit: 20
    t.string "REPST",      limit: 4
    t.string "REPZIP",     limit: 10
    t.string "REPPHONE",   limit: 20
    t.string "REPNOTES",   limit: 50
    t.string "REPMODUSER", limit: 16
    t.date   "REPMODTIME"
    t.string "REPDIRPAY",  limit: 1
    t.date   "REPDFEE"
    t.date   "REPFEERECV"
    t.date   "REPLASTDOC"
    t.date   "REPFEEDISP"
    t.string "REPCORKEY",  limit: 16
    t.date   "REPACKNW"
  end

  create_table "RMDREA", primary_key: "RMDKEY", force: :cascade do |t|
    t.string  "RMDVAL",      limit: 2
    t.string  "RMDMDUSR",    limit: 16
    t.date    "RMDMDTIM"
    t.string  "RMDPRIORITY", limit: 2
    t.integer "RMDISSSEQ",   limit: 4
    t.string  "RMDDEV",      limit: 2
  end

  create_table "STAFF", primary_key: "STAFKEY", force: :cascade do |t|
    t.string  "SUSRPW",    limit: 16
    t.string  "SUSRSEC",   limit: 5
    t.string  "SUSRTYP",   limit: 10
    t.string  "SSALUT",    limit: 15
    t.string  "SNAMEF",    limit: 24
    t.string  "SNAMEMI",   limit: 4
    t.string  "SNAMEL",    limit: 60
    t.string  "SLOGID",    limit: 16
    t.string  "STITLE",    limit: 60
    t.string  "SORG",      limit: 60
    t.string  "SDEPT",     limit: 60
    t.string  "SADDRNUM",  limit: 10
    t.string  "SADDRST1",  limit: 30
    t.string  "SADDRST2",  limit: 30
    t.string  "SADDRCTY",  limit: 20
    t.string  "SADDRSTT",  limit: 4
    t.string  "SADDRCNTY", limit: 6
    t.string  "SADDRZIP",  limit: 10
    t.string  "STELW",     limit: 20
    t.string  "STELWEX",   limit: 20
    t.string  "STELFAX",   limit: 20
    t.string  "STELH",     limit: 20
    t.string  "STADUSER",  limit: 16
    t.date    "STADTIME"
    t.string  "STMDUSER",  limit: 16
    t.date    "STMDTIME"
    t.integer "STC1",      limit: 4
    t.integer "STC2",      limit: 4
    t.integer "STC3",      limit: 4
    t.integer "STC4",      limit: 4
    t.string  "SNOTES",    limit: 80
    t.integer "SORC1",     limit: 4
    t.integer "SORC2",     limit: 4
    t.integer "SORC3",     limit: 4
    t.integer "SORC4",     limit: 4
    t.string  "SACTIVE",   limit: 1
    t.string  "SSYS",      limit: 16
    t.string  "SSPARE1",   limit: 20
    t.string  "SSPARE2",   limit: 20
    t.string  "SSPARE3",   limit: 20
    t.string  "SMEMGRP",   limit: 16
    t.integer "SFOIASEC",  limit: 4
    t.integer "SRPTSEC",   limit: 4
    t.string  "SATTYID",   limit: 4
    t.string  "SVLJ",      limit: 1
  end

  create_table "VFTYPES", id: false, force: :cascade do |t|
    t.string "FTKEY",    limit: 10
    t.string "FTDESC",   limit: 100
    t.string "FTADUSR",  limit: 16
    t.date   "FTADTIM"
    t.string "FTMDUSR",  limit: 16
    t.date   "FTMDTIM"
    t.string "FTACTIVE", limit: 1
    t.string "FTTYPE",   limit: 16
    t.string "FTSYS",    limit: 16
    t.string "FTSPARE1", limit: 20
    t.string "FTSPARE2", limit: 20
    t.string "FTSPARE3", limit: 20
  end

end
