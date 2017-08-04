class Rms::ApplicantController < Rms::ApplicationController
  before_filter :verify_access

  def index
    @applicant = Bvadmin::EmployeeApplicant.new
    @applicants = Bvadmin::PotentialApplicant.newsearch(params.dig(:applicant, :fname),
                                                        params.dig(:applicant, :lname)).
                                                        order('FNAME ASC').
                                                        paginate(per_page: 10, page: params[:page])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @applicant = Bvadmin::EmployeeApplicant.new
    @application = Bvadmin::EmployeeApplication.new
  end

  def edit
    @applicant = Bvadmin::EmployeeApplicant.find(params[:id])

  rescue ActiveRecord::RecordNotFound
    flash[:error] = { 'Applicant': 'Invalid ID' }
    redirect_to rms_applicant_path
  end

  def create
    @applicant = Bvadmin::EmployeeApplicant.new(params.require(:applicant).
                                                permit(:fname, :lname))

    if @applicant.valid?
      @applicant.save

      flash[:notice] = "Applicant #{@applicant.lname}, #{@applicant.fname} created."
      redirect_to rms_applicant_edit_path(@applicant)
    else
      flash[:error] = @applicant.errors

      @applicants = Bvadmin::PotentialApplicant.newsearch(params.dig(:applicant, :fname),
                                                          params.dig(:applicant, :lname)).
                                                          order('FNAME ASC').
                                                          paginate(per_page: 10, page: params[:page])

      render 'rms/applicant/index'
    end
  end

  def new_search
    applicant = Bvadmin::PotentialApplicant.newsearch(params.dig(:applicant, :fname),
                                                      params.dig(:applicant, :lname))
    render json: {
      'last' => lambda { applicant.select(:lname).distinct.order('LNAME ASC').first(15).map(&:lname) },
      'first' => lambda { applicant.select(:fname).distinct.order('FNAME ASC').first(15).map(&:fname) },
    }.fetch(params[:searchtype], lambda { [] }).call
  end

  def copy
    employee = Bvadmin::Employee.find(params[:id])
    applicant = Bvadmin::EmployeeApplicant.new(fname: employee.fname,
                                               lname: employee.lname,
                                               grade: employee.grade,
                                               series: employee.job_code)

    applicant.save

    flash[:notice] = "Applicant #{applicant.lname}, #{applicant.fname} created."
    redirect_to rms_applicant_edit_path(applicant)

  rescue ActiveRecord::RecordNotFound
    flash[:error] = { 'Invalid Employee': 'Could not create that employee as an applicant' }
    redirect_to rms_applicant_path
  end

  def delete
    @applicant = Bvadmin::EmployeeApplicant.find(params[:id])
    if @applicant.delete
      flash[:notice] = "#{@applicant.fname} #{@applicant.lname} was deleted."
    else
      flash[:notice] = "could not delete #{@applicant.fname} #{@applicant.lname}"
    end

    @applicants = Bvadmin::PotentialApplicant.newsearch(params.dig(:applicant, :fname),
                                                        params.dig(:applicant, :lname)).
                                                        order('FNAME ASC').
                                                        paginate(per_page: 10, page: params[:page])

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

private

  def verify_access
    raise Rms::Error::UserAuthenticationError, "#{current_user.name} does not have access to this resource." unless current_user.has_role? :admin, :employee

    #adding placeholder here to check to see if the current user has priveledges to view private information
    #this will eventually pull from the roles tables, but for now, just setting a constant variable
    unless current_user.has_role? :admin
       @view_private_info = false
    else
       @view_private_info = true
    end
  end
  
  def applicant_params
    params.require(:applicant).permit()
  end
end
