class Rms::ReportsController < Rms::ApplicationController
  before_filter :verify_access

  def index
  end

  def pipeline
    @titles = Bvadmin::Employee.paid_titles_list#.unshift [ "ALL", "ALL" ]
    @series = Bvadmin::Employee.job_code_list#.unshift [ "ALL", "ALL" ]
    @grades = Bvadmin::Employee.grades_list#.unshift [ "ALL", "ALL" ]
    @effectives = Bvadmin::Employee.effectives_list#.unshift [ "ALL", "ALL" ]

    render layout: false
  end

  def snapshot
    @paidtitles = Bvadmin::Employee.paid_titles_list.unshift [ "ALL", "ALL" ]
    @series = Bvadmin::Employee.job_code_list.unshift [ "ALL", "ALL" ]
    @grades = Bvadmin::Employee.grades_list.unshift [ "ALL", "ALL" ]
    @bvatitles = Bvadmin::Employee.bva_titles_list.unshift [ "ALL", "ALL" ]
    @units = Bvadmin::Employee.job_code_list.unshift [ "ALL", "ALL" ]
    @eods = Bvadmin::Employee.effectives_list.unshift [ "ALL", "ALL" ]

    render layout: false
  end

  # GET /rms/reports/fte
  def fte
    render layout: false
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
      render layout: false

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
    raise Rms::Error::AuthenticationError, "#{current_user.name} does not have access to this resource." unless current_user.has_role? :report, :admin
  end
end
