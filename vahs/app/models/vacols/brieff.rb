class Vacols::Brieff < Vacols::Record
  self.table_name = "BRIEFF"
  

  scope :form_completed, -> {where.not(:BFD19 => nil)}
  scope :check_action, -> {where("BFHA = 3 OR BFHA IS NULL")}
  scope :is_advanced, -> {where(:BFMPRO => 'ADV')}
  scope :is_remanded, -> {where(:BFMPRO => 'REM')}
  scope :limit_docdate, ->(docdate) {where("BFD19 < ?", docdate)}
  scope :new_tb_request, -> {where("BFDTB > BFDDEC")}
  scope :tb_request, -> {where.not(:BFDTB => nil)}

  #This is not a great way to do this but the OR was causing issues.
  #Also am unsure how to check vacols.hearing_held_postrem(bfkey, bfddec) <> 'Y'
  def self.check_pending(docdate)
    where("((`BRIEFF`.`BFD19` IS NOT NULL AND `BRIEFF`.`BFMPRO` = "\
     "'ADV' AND (`BRIEFF`.`BFHA` = 3 OR `BRIEFF`.`BFHA` IS NULL) AND"\
      "`BRIEFF`.`BFD19` < '"+ docdate +"') OR (`BRIEFF`.`BFMPRO` = 'REM'"\
      " AND `BRIEFF`.`BFDTB` IS NOT NULL AND BFDTB > BFDDEC))")
    #is_remanded.tb_request.new_tb_request.limit_docdate(docdate)
    #form_completed.check_action.is_advanced.limit_docdate(docdate)
    #where{(form_completed.check_action.is_advanced.limit_docdate(docdate)) | (is_remanded.tb_request.new_tb_request.docdate(docdate))}
  end

  def self.travel_board(docdate)
    check_pending(docdate).where(:BFHR => 2)
  end

  def self.central_office(docdate)
    check_pending(docdate).where(:BFHR => 1, :BFDOCIND => 'N')
  end

  def self.video(docdate)
    check_pending(docdate).where(:BFHR => 1,:BFDOCIND => 'Y')
  end


  def fiscal_year
  begin
    temp = Date.new(2000, 9, 30)
    case
    when (self.BFD19 <= temp)
      0
    when (self.BFD19 <= temp + 5.years)
      1
    when (self.BFD19 <= temp + 10.years)
      2
    when (self.BFD19 <= temp + 15.years)
      3
    when (self.BFD19 <= temp + 16.years)
      4
    when (self.BFD19 <= temp + 17.years)
      5
    else
      puts "error"
    end
  rescue
    puts "error"
  end
  end 


  def self.do_work(docdate, hType, rsType)
  begin
    case hType
    when "1"
      central_office(docdate)
    when "2"
      travel_board(docdate)
    when "6"
      video(docdate)
    when 0
      limit_docdate(docdate)
    else
      puts "error"
    end
  rescue
    puts "error"
  end
  end
end