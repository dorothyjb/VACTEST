=begin
class Vacols::Brieff < Vacols::Record
  self.table_name = "VACOLS.BRIEFF"

  scope :form_completed, -> {where.not(:BFD19 => nil)}
  scope :check_action, -> {where("BFHA = 3 OR BFHA IS NULL")}
  scope :is_advanced, -> {where(:BFMPRO => 'ADV')}
  scope :is_remanded, -> {where(:BFMPRO => 'REM')}
  scope :limit_docdate, ->(docdate) {where("BFD19 < ?", docdate)}
  scope :new_tb_request, -> {where("BFDTB > BFDDEC")}
  scope :tb_request, -> {where.not(:BFDTB => nil)}

  scope :travel_board, -> {check_pending.where(:BFHR => 2)}
  scope :central_office2, ->{check_pending.where(:BFHR => 1)}
  scope :central_office, -> {central_office2.where(:BFDOCIND => nil)}
  scope :video, -> {check_pending.where(:BFHR => 1,:BFDOCIND => 'V')}

  #This is not a great way to do this but the OR was causing issues.
  #Also am unsure how to check vacols.hearing_held_postrem(bfkey, bfddec) <> 'Y'

    #is_remanded.tb_request.new_tb_request.limit_docdate(docdate)
    #form_completed.check_action.is_advanced.limit_docdate(docdate)
    #where{(form_completed.check_action.is_advanced.limit_docdate(docdate)) | (is_remanded.tb_request.new_tb_request.docdate(docdate))}

  # Where
  #   date form 9 received is not NULL
  #   appeal status is 'ADV'
  #   and hearing action is 3 or hearing action is NULL
  #   or
  #   appeal status is 'REM'
  #   and date/time of travel board request is greater than date/time of
  #   decision.
  scope :check_pending, -> {where("((BRIEFF.BFD19 IS NOT NULL"\
    " AND BRIEFF.BFMPRO = 'ADV' AND (BRIEFF.BFHA = 3 OR"\
    " BRIEFF.BFHA IS NULL)) OR (BRIEFF.BFMPRO = 'REM'"\
    " AND BRIEFF.BFDTB IS NOT NULL AND BFDTB > BFDDEC))")}

  def i9_received
    self[:BFD19] || self[:bfd19]
  end

  #Docket date is always based on the Last Day of the selected Month/Year
  #Add one month to the selected date in order to test for Less Than (<) 
  # the first day of the following month
  def in_docdate?(docdate)
    self.i9_received <= Date.parse(docdate) + 1.month
  end

  #Hack to ensure the data from the database is stripped of any leading/trailing whitespace
  def regional_office
    (self[:BFREGOFF] || self[:bfregoff]).to_s.lstrip
  end

  def self.get_report(docdate, htype, fiscal_years)
    result = Hash.new(nil)
    ttlBfDocDate = 0
    brieffs = Vacols::Brieff.do_work(htype)

    brieffs.each do |brieff|
      roID = brieff.regional_office
      result[roID] ||= Vacols::RegionalOffice.new(roID, fiscal_years)
      result[roID].update_fiscal_year(brieff)
      result[roID].total_pending += 1
      result[roID].docdate_total += 1 if brieff.in_docdate?(docdate)
    end

    result.each { |key, rst| ttlBfDocDate += rst.docdate_total }

    [ result, ttlBfDocDate, brieffs.length ]
  end

  def self.do_work(hType)
    case hType
      when "1"
        central_office
      when "2"
        travel_board
      when "6"
        video
      else
        raise Exception, "invalid hType"
    end
  end
end
=end
