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

  def fte
     @empftes = Bvadmin::Employee.emp_fte_report
     @cur_pp = Bvadmin::Payperiod.cur_pp
     @next_pp = Bvadmin::Payperiod.next_pp
     startdate = @cur_pp.first.startdate
     next_startdate = @next_pp.first.startdate
     next_enddate = @next_pp.first.enddate
     @fte_losses = Bvadmin::Employee.fte_losses(startdate, startdate)
     @fte_new_hires = Bvadmin::EmployeeApplicant.fte_new_hires(next_startdate, next_enddate)


      render layout: false
   end

  private
  def verify_access
    raise Rms::Error::AuthenticationError, "#{current_user.name} does not have access to this resource." unless current_user.has_role? :report, :admin
  end
end
