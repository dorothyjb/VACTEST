class Vacols::Brieff < Vacols::Record
  self.table_name = "BRIEFF"

  scope :form_completed, -> {where.not(:BFD19 => nil)}
  scope :check_action, -> {where("BFHA = 3 OR BFHA IS NULL")}
  scope :is_advanced, -> {where(:BFMPRO => 'ADV')}
  scope :is_remanded, -> {where(:BFMPRO => 'REM')}
  scope :limit_docdate, ->(docdate) {where("BFD19 < ?", docdate)}
  scope :new_tb_request, -> {where("BFDTB > BFDDEC")}
  scope :tb_request, -> {where.not(:BFDTB => nil)}

  scope :travel_board, -> {check_pending.where(:BFHR => 2)}
  scope :central_office, -> {check_pending.where(:BFHR => 1, :BFDOCIND => 'N')}
  scope :video, -> {check_pending.where(:BFHR => 1,:BFDOCIND => 'Y')}

  #This is not a great way to do this but the OR was causing issues.
  #Also am unsure how to check vacols.hearing_held_postrem(bfkey, bfddec) <> 'Y'

    #is_remanded.tb_request.new_tb_request.limit_docdate(docdate)
    #form_completed.check_action.is_advanced.limit_docdate(docdate)
    #where{(form_completed.check_action.is_advanced.limit_docdate(docdate)) | (is_remanded.tb_request.new_tb_request.docdate(docdate))}

	scope :check_pending, -> {where("((`BRIEFF`.`BFD19` IS NOT NULL"\
    " AND `BRIEFF`.`BFMPRO` = 'ADV' AND (`BRIEFF`.`BFHA` = 3 OR"\
    "`BRIEFF`.`BFHA` IS NULL)) OR (`BRIEFF`.`BFMPRO` = 'REM'"\
      " AND `BRIEFF`.`BFDTB` IS NOT NULL AND BFDTB > BFDDEC))")}
#runs from the first so need to add one month
  def in_docdate(docdate)
    self.BFD19 <= Date.parse(docdate) + 1.month
  end

  def get_regional_office()
    self.BFREGOFF.to_s.lstrip
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

  def self.get_report(docdate, htype, rstype)
    temp = BrieffReport.new(docdate, htype, rstype)
    temp.get_pending_results
  end

  def self.do_work(hType, rsType)
	  begin
		case hType
		when "1"
		  central_office
		when "2"
		  travel_board
		when "6"
		  video
		when 0
		  limit_docdate
		else
		  puts "error"
		end
	  rescue
		puts "error"
	  end
  end
end