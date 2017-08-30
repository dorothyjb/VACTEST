class Rms::ReportsController < Rms::ApplicationController
  before_filter :verify_access

  def index
  end

  # GET /rms/reports/pipeline
  def pipeline
    @titles = Bvadmin::Employee.paid_titles_list#.unshift [ "ALL", "ALL" ]
    @series = Bvadmin::Employee.job_code_list#.unshift [ "ALL", "ALL" ]
    @grades = Bvadmin::Employee.grades_list#.unshift [ "ALL", "ALL" ]
    @effectives = Bvadmin::Employee.effectives_list#.unshift [ "ALL", "ALL" ]

    render layout: false
  end

  # POST /rms/reports/pipeline
  def pipeline_export
    return redirect_to root_path if params[:cancel]
    
    redirect_to rms_reports_path, notice: 'Pipeline report not yet implemented.'
  end

  # GET /rms/reports/snapshot
  def snapshot
    @paidtitles = Bvadmin::Employee.paid_titles_list
    @series = Bvadmin::Employee.job_code_list
    @grades = Bvadmin::Employee.grades_list
    @bvatitles = Bvadmin::Employee.bva_titles_list
    @status = Bvadmin::WorkforceRoster.select(:status).distinct.order('status asc').collect { |wfr| [ wfr.status, wfr.status ] }

    render layout: false
  end

  # POST /rms/reports/snapshot
  def snapshot_export
    return render 'rms/reports/workforce/cancel' if params[:cancel]

    @offices = Bvadmin::RmsOrgOffice.all
    @filters = { status: params[:unit],
                 official_titles: params[:paidtitle],
                 unofficial_titles: params[:bvatitle],
                 series: params[:series],
                 grades: params[:grade],
                 eod_end: params[:eod_to],
                 eod_start: params[:eod_from],
                 status: params[:status],
               }

    render 'rms/reports/workforce'
  end

  # GET /rms/reports/fte
  def fte
    @empftes = Bvadmin::Employee.emp_fte_report
    @cur_pp = Bvadmin::Payperiod.cur_pp
    @next_pp = Bvadmin::Payperiod.next_pp
    startdate = @cur_pp.first.startdate
    next_startdate = @next_pp.first.startdate
    next_enddate = @next_pp.first.enddate
    @fte_losses = Bvadmin::Employee.fte_losses(startdate, startdate)
    @fte_new_hires = Bvadmin::EmployeeApplicant.fte_new_hires(next_startdate, next_enddate)

    @pg_empftes = @empftes.paginate(page: params['empfte_pg'], per_page: 10)
    @pg_fte_losses = @fte_losses.paginate(page: params['fte_losses_pg'], per_page: 10)
    @pg_fte_new_hires = @fte_new_hires.paginate(page: params['fte_new_pg'], per_page: 10)

    respond_to do |format|
      format.html { render layout: false }
      format.js { render file: 'rms/reports/fte/update.js.erb' }
    end
  end

  # POST /rms/reports/fte
  def fte_export
    @empftes = Bvadmin::Employee.emp_fte_report
    @cur_pp = Bvadmin::Payperiod.cur_pp
    @next_pp = Bvadmin::Payperiod.next_pp
    startdate = @cur_pp.first.startdate
    next_startdate = @next_pp.first.startdate
    next_enddate = @next_pp.first.enddate
    @fte_losses = Bvadmin::Employee.fte_losses(startdate, startdate)
    @fte_new_hires = Bvadmin::EmployeeApplicant.fte_new_hires(next_startdate, next_enddate)

    fte_report = Rms::Reports::FTE.new

    case params[:export_format]
    when "HTML"
      render layout: 'plain'

    when "MS Excel"
      content = fte_report.xls
      send_data content, filename: fte_report.filename,
                         type: fte_report.filetype,
                         disposition: 'attachment'

    when "PDF"
      content = fte_report.pdf
      send_data content, filename: fte_report.filename,
                         type: fte_report.filetype,
                         disposition: 'attachment'
    else
      redirect_to rms_reports_path
    end
  end

  private
  def verify_access
    raise Rms::Error::UserAuthenticationError, "#{current_user.name} does not have access to this resource." unless current_user.has_role? :report, :admin
  end
end
