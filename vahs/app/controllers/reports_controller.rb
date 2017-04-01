class ReportsController < ApplicationController

  # Docket Range Reporting 
  def docket
    @docdate = params[:docdate]
    @hType = params[:hType]
  end

  # POST function for docket
  def getDocket
    @docdate = params[:docdate]+"-01"
    @hType = params[:hType]
    @shType = getHearingType(@hType)
    
    #Object to hold totals
    # - fyCol: Columns for the FY breakdown
    # - bfDocDate: total of the records that are before Docket Date (bfDocDate)
    # - ttlPending: total of all returned records
    @ttls = {
      'fyCol' => nil,
      'bfDocDate' => 0, 
      'ttlPending' => 0
    }
    
    #Get the data 
    @output, @ttls["bfDocDate"], @ttls["ttlPending"] = Vacols::Brieff.get_report(@docdate, @hType, session[:docket_fiscal_years])
    @output = @output.sort_by { |h, obj| obj.total_pending }.sort_by { |h, obj| obj.docdate_total }.reverse
    @fiscal_years = @output.first[1].fiscal_years
    @ttls['fyCol'] = Array.new(@fiscal_years.length, 0)

    @output.each do |roName,obj|
      obj.fiscal_years.each_with_index do |fy, i|
        @ttls['fyCol'][i] += fy[:total]
      end
    end

    # XLS Export
    unless params[:ViewResults]
      xls = docket_xls_export
      send_data xls.string, filename: 'docket.xls', type: 'application/vnd.ms-excel'
    else
      render :docket
    end

  rescue Exception
    @err = true
    render :docket
  end

  # Docket FY Analysis Reporting 
  def analysis
    @docdate = params[:docdate]
    @hType = params[:hType]
    @numJudge = params[:numJudge]
    @judgeMult = params[:judgeMult]
    @coDays = params[:coDays]  
  end

  # POST function for analysis
  def getAnalysis
    @docdate = params[:docdate]+"-01"
    @hType = params[:hType]
    @shType = getHearingType(@hType)
    
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
      send_data xls.string, filename: 'analysis.xls', type: 'application/vnd.ms-excel'
    else
      render :analysis
    end
  rescue Exception
    @err = true
    render :analysis
  end

  def fiscalyears
    render layout: false
  end

  def update_fiscalyears
    fys = [
            params['fy_begin'] || [],
            params['fy_end'] || []
          ].transpose

    fys.each do |fy|
      fy[0] = "1970-09-30" if fy[0].empty?
      fy[1] = Date.today.to_s if fy[1].empty?
    end

    fys.sort! { |a,b| Date.parse(a[0]) <=> Date.parse(b[0]) }

    session[:docket_fiscal_years] = fys

    render layout:  false
  end

  def docket_xls_export
    data = StringIO.new
    book = Spreadsheet::Workbook.new
    sheet = book.create_worksheet(name: @shType)
    fyrs = @fiscal_years.collect { |fy| fy[:display] }
    header = [ 'Regional Office', 'Type', 'Total Pending', "Pending (Pre #{@docdate})", 'Percentage' ]
    boldfmt = Spreadsheet::Format.new({weight: :bold})
    header += fyrs

    sheet.row(0).default_format = boldfmt
    sheet.row(0).concat header

    xls_resize_column sheet, header

    idx = 1
    @output.each do |roID, obj|
      entry = [ "#{obj.station_id}-#{obj.regional_office[:city]}", @shType, obj.total_pending, obj.docdate_total, obj.percentage_s(@ttls['bfDocDate']), ]
      entry += obj.fiscal_years.collect { |fy| fy[:total] }

      xls_resize_column sheet, entry
      sheet.row(idx).concat entry

      idx += 1
    end

    entry = [ "", "Totals", @ttls['ttlPending'], @ttls['bfDocDate'], "" ] + @ttls['fyCol']
    xls_resize_column sheet, entry

    sheet.row(idx).concat Array.new(sheet.row(0).length, "")
    sheet.row(idx+1).default_format = boldfmt
    sheet.row(idx+1).concat entry

    book.write data
    data
  end

  def analysis_xls_export
    data = StringIO.new
    book = Spreadsheet::Workbook.new
    boldfmt = Spreadsheet::Format.new({weight: :bold})
    sheet = book.create_worksheet(name: @shType)

    header = [ 'Regional Office', 'Total Pending', "Pending (Pre #{@docdate})", 'Percentage' ]
    header += analysis_header

    sheet.row(0).default_format = boldfmt
    sheet.row(0).concat header

    xls_resize_column sheet, header

    idx = 1
    @output.each do |roID, obj|
      entry = [ "#{obj.station_id}-#{obj.regional_office[:city]}", obj.total_pending, obj.docdate_total, obj.percentage_s(@ttls['bfDocDate']), ]
      entry += analysis_content(obj)

      xls_resize_column sheet, entry
      sheet.row(idx).concat entry

      idx += 1
    end

    entry = [ "Totals", @ttls['ttlPending'], @ttls['bfDocDate'], '', @ttls['ttlJudgeDays'], @ttls['ttlAdded'] ]

    sheet.row(idx).concat Array.new(sheet.row(0).length, "")
    sheet.row(idx+1).default_format = boldfmt
    sheet.row(idx+1).concat entry

    book.write data
    data
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

  def xls_resize_column sheet, entry
    entry.each_with_index do |e, i|
      sheet.column(i).width = e.to_s.length + 5 if sheet.column(i).width < (e.to_s.length + 5)
    end
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

  #Function for returning the string for the type of hearing selected
  def getHearingType(hType)
    result = Hash.new("")
    result['1'] = "Central Office"
    result['2'] = "Travel Board"
    result['6'] = "Video"

    result[hType]
  end
end
