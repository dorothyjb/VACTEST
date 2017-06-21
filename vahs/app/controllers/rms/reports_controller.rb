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
    render layout: false
  end

  private
  def verify_access
    raise Rms::Error::AuthenticationError, "#{current_user.name} does not have access to this resource." unless current_user.has_role? :report, :admin
  end
end
