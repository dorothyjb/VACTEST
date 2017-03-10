class Vacols::Brieff < Vacols::Record
	self.table_name = "BRIEFF"

	alias_attribute :folder_number, :BFKEY
	alias_attribute :date_of_decision, :BFDDEC
	alias_attribute :corres_key, :BFCORKEY
	alias_attribute :appellant_id, :BFCORLID
	alias_attribute :stays_indicator, :BFDCN
	alias_attribute :vid_hearing_req_indicator, :BFDOCIND
	alias_attribute :insurance_loan_number, :BFPDNUM
	alias_attribute :date_of_prior_decision, :BFDPDCN
	alias_attribute :thurber_date, :BFDTHURB #obsolete
	alias_attribute :date_of_disagreement_received, :BFDNOD
	alias_attribute :date_of_statement_case_issued, :BFDSOC
	alias_attribute :date_of_form_9_received, :BFD19
	alias_attribute :date_of_certified_bva, :BF41STAT
	alias_attribute :mail_status, :BFMSTAT
	alias_attribute :appeal_status, :BFMPRO
	alias_attribute :date_mail_control, :BFDMCON
	alias_attribute :regional_office, :BFREGOFF
	alias_attribute :number_of_issues, :BFISSNR
	alias_attribute :remand_destination, :BFRDMREF
	alias_attribute :appeal_program_area, :BFCASEV
	alias_attribute :decission_team, :BFBOARD
	alias_attribute :date_assigned_to_decission_team, :BFBSASGN
	alias_attribute :attorney_id, :BFATTID
	alias_attribute :date_assigned_to_attorney, :BFDASGN
	alias_attribute :cavc_folder_number, :BFCCLKID
	alias_attribute :date_sent_to_quality_review, :BFDQRSNT
	alias_attribute :date_location_in, :BFDLOCIN
	alias_attribute :date_location_out, :BFDLOCOUT
	alias_attribute :medical_facility, :BFSTASGN
	alias_attribute :current_location_of_case_file, :BFCURLOC
	alias_attribute :number_copies_of_duplication, :BFNRCOPY
	alias_attribute :board_members_id, :BFMEMID
	alias_attribute :board_date_assigned_boardmember, :BFDMEM
	alias_attribute :number_copies_of_congressional_interest, :BFNRCI
	alias_attribute :outbased_travel_board_ind, :BFCALLUP
	alias_attribute :capri_patient_list_adddel_indicator, :BFCALLYYMM
	alias_attribute :ats_status, :BFHINES # No longer used
	alias_attribute :dro_informal_hearing, :BFDCFLD1
	alias_attribute :dro_formal_hearing, :BFDCFLD2
	alias_attribute :dro, :BFDCFLD3
	alias_attribute :type_action, :BFAC
	alias_attribute :disposition_of_appeal, :BFDC
	alias_attribute 

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

	scope :check_pending, -> {where("((`BRIEFF`.`BFD19` IS NOT NULL"\
    " AND `BRIEFF`.`BFMPRO` = 'ADV' AND (`BRIEFF`.`BFHA` = 3 OR"\
    "`BRIEFF`.`BFHA` IS NULL)) OR (`BRIEFF`.`BFMPRO` = 'REM'"\
      " AND `BRIEFF`.`BFDTB` IS NOT NULL AND BFDTB > BFDDEC))")}

	#Docket date is always based on the Last Day of the selected Month/Year
	#Add one month to the selected date in order to test for Less Than (<) 
	# the first day of the following month
	def in_docdate(docdate)
		self.BFD19 <= Date.parse(docdate) + 1.month
	end

	#Hack to ensure the data from the database is stripped of any leading/trailing whitespace
	def get_regional_office()
		self.BFREGOFF.to_s.lstrip
	end

	#Test case for use in compiling which FY column the Docket entry fits into
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
