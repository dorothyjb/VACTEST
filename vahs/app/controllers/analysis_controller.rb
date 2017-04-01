class AnalysisController < ApplicationController
  include XLSHelper

  # Docket FY Analysis Reporting 
  def get
    @docdate = params[:docdate]
    @hType = params[:hType]
    @numJudge = params[:numJudge]
    @judgeMult = params[:judgeMult]
    @coDays = params[:coDays]  

    render :analysis
  end

  # POST function for analysis
  def post
    @docdate = params[:docdate]+"-01"
    @hType = params[:hType]
    @shType = get_hearing_type(@hType)
    
    #Temporary Hack to get values from the form
    # - The form fields will be replaced once an analysis 
    #   parameters configuration page is implemented
    @numJudge = params[:numJudge]
    @judgeMult = params[:judgeMult]
    @coDays = params[:coDays]  
    @judgeDays = 0  #Calculated Judge Days for Video Hearings Analysis
    
    #Object to hold totals
    # - bfDocDate: total of the records that are before Docket Date (bfDocDate)
    # - ttlPending: total of all returned records
    # - ttlJudgeDays: total of all RO's Judge days
    # - ttlAdded: total of all days add by RO Juedge Day calculations 
    @ttls = {
        'bfDocDate' => 0,
        'ttlPending' => 0,
        'ttlJudgeDays' => 0,
        'ttlAdded' => 0
    }
    
    #Case to determine what calculations need to be done for the appropriate requested analysis
    case @hType
      when "1"
        @judgeDays = @coDays.to_i - 3 #need to look into this minus 3
      when "2"
        @judgeDays = 0
       when "6"
       # The additional subtraction of 12 is because of ??? Holidays ???
       # Excel Example: 1331 = ((( 57 * 2.25 ) * 12 ) - 12 ) - 196 
       @judgeDays = (((@numJudge.to_f * @judgeMult.to_f) * 12))-@coDays.to_i
    end
    
    #Get the data 
    @output, @ttls["bfDocDate"], @ttls["ttlPending"] = Vacols::Brieff.get_report(@docdate, @hType, session[:docket_fiscal_years])
    @output = @output.sort_by { |h, obj| obj.total_pending }.sort_by { |h, obj| obj.docdate_total }.reverse

    unless params[:ViewResults]
      xls = analysis_xls_export
      send_data xls.string, filename: "#{@shType} Analysis.xls", type: 'application/vnd.ms-excel'
    else
      render :analysis
    end
  rescue Exception
    @err = true
    render :analysis
  end

  def analysis_xls_export
    header = [ 'Regional Office', 'Total Pending', "Pending (Pre #{@docdate})", 'Percentage' ]
    header += analysis_header

    xls = XLSSpreadsheet.new(@shType, header)

    @output.each do |roID, obj|
      entry = [ "#{obj.station_id}-#{obj.regional_office[:city]}", obj.total_pending, obj.docdate_total, obj.percentage_s(@ttls['bfDocDate']), ]
      entry += analysis_content(obj)

      xls.add_entry entry
    end

    xls.add_entry Array.new(xls.total_columns, "")
    xls.add_entry [ "Totals", @ttls['ttlPending'], @ttls['bfDocDate'], '', @ttls['ttlJudgeDays'], @ttls['ttlAdded'] ], xls.format

    xls.process
  end

  def analysis_content ro
    pct_ro = ro.percentage(@ttls['bfDocDate'].to_f)
    judge_days = (pct_ro * @judgeDays.to_f).round(0) 

    case @hType
      when '1'
        added_days = judge_days * 11
        @ttls['ttlJudgeDays'] += judge_days
        @ttls['ttlAdded'] += added_days

        entry = [ judge_days.to_s, added_days.to_s ]
      when '2'
        entry = []
      when '6'
        added_days = judge_days * ro.tz_value
        @ttls['ttlJudgeDays'] += judge_days
        @ttls['ttlAdded'] += added_days

        entry = [ judge_days.to_s, added_days.to_s, ro.tz_value ]
      else
        entry = []
    end

    entry
  end

  def analysis_header
    result = Hash.new([])

    # Central Office
    result['1'] = [ 'Judge Days Added', 'Total Hearings Added' ]

    # Travel Board
    result['2'] = [ 'Judge Trips Added', 'Total Hearings Added', 'TBD' ]

    # Video
    result['6'] = [ 'Judge Days Added', 'Total Hearings Added', 'Hearings Per Day (Based on Timezone)' ]

    result[@hType]
  end
end
