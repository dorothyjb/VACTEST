=begin
class DocketController < ApplicationController
  include XLSHelper

  def get
    @docdate = params[:docdate]
    @hType = params[:hType]

    render :docket
  end

  def post
    @docdate = params[:docdate]+"-01"
    @hType = params[:hType]
    @shType = get_hearing_type(@hType)
    
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
      send_data xls.string, filename: "#{@shType} Docket.xls", type: 'application/vnd.ms-excel'
    else
      render :docket
    end

  rescue Exception
    @err = true
    render :docket
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
    header = [ 'Regional Office', 'Type', 'Total Pending', "Pending (Pre #{@docdate})", 'Percentage' ]
    header += @fiscal_years.collect { |fy| fy[:display] }

    xls = XLSSpreadsheet.new(@shType, header)

    @output.each do |roID, obj|
      entry = [ "#{obj.station_id}-#{obj.regional_office[:city]}", @shType, obj.total_pending, obj.docdate_total, obj.percentage_s(@ttls['bfDocDate']), ]
      entry += obj.fiscal_years.collect { |fy| fy[:total] }

      xls.add_entry entry
    end

    xls.add_entry Array.new(xls.total_columns, "")
    xls.add_entry [ "", "Totals", @ttls['ttlPending'], @ttls['bfDocDate'], "" ] + @ttls['fyCol'], xls.format

    xls.process
  end
end
=end
