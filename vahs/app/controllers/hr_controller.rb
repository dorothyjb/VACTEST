class HrController < ApplicationController
  def index
  end

  def employee_new
    @employee = Bvadmin::Employee.new
  end

  def employee_edit
    @employee = Bvadmin::Employee.find(params[:id])
  end

  def employee
    if params['search'] && params['search_type']
      @employees = Bvadmin::Employee.search(params['search_type'], params['search']).order('LNAME ASC')
      @results_total = @employees.length
      @search_entry_text = params['search_type'] == 'Generic' ? 'FTE' : params['search_type']
    else
      @employees = Bvadmin::Employee.none
      @results_total = nil
      @search_entry_text = nil
    end

    @employees = @employees.paginate(page: params['page'], per_page: 15)
  end

  def search
    if params['search'] && params['search_type']
      @employees = Bvadmin::Employee.search(params['search_type'], params['search']).order('LNAME ASC')
      @results_total = @employees.length
      @search_entry_text = params['search_type'] == 'Generic' ? 'FTE' : params['search_type']
    else
      @employees = Bvadmin::Employee.none
      @results_total = nil
      @search_entry_text = nil
    end

    @employees = @employees.paginate(page: params['page'], per_page: 15)
  end

  def show
    @employee = Bvadmin::Employee.find(params[:id])
  end

  def reports
  end

  def reports_pipeline
    @titles = Bvadmin::Employee.paid_titles_list#.unshift [ "ALL", "ALL" ]
    @series = Bvadmin::Employee.job_code_list#.unshift [ "ALL", "ALL" ]
    @grades = Bvadmin::Employee.grades_list#.unshift [ "ALL", "ALL" ]
    @effectives = Bvadmin::Employee.effectives_list#.unshift [ "ALL", "ALL" ]

    render "hr/reports/pipeline"
  end

  def reports_snapshot
    @paidtitles = Bvadmin::Employee.paid_titles_list.unshift [ "ALL", "ALL" ]
    @series = Bvadmin::Employee.job_code_list.unshift [ "ALL", "ALL" ]
    @grades = Bvadmin::Employee.grades_list.unshift [ "ALL", "ALL" ]
    @bvatitles = Bvadmin::Employee.bva_titles_list.unshift [ "ALL", "ALL" ]
    @units = Bvadmin::Employee.job_code_list.unshift [ "ALL", "ALL" ]
    @eods = Bvadmin::Employee.effectives_list.unshift [ "ALL", "ALL" ]
    
    render "hr/reports/snapshot"
  end
end
