class Rms::ApplicantController < Rms::ApplicationController
  before_filter :verify_access, except: [ :locator ]
  before_filter :check_for_cancel, only: [ :create ]

  def new
    @applicant = Bvadmin::EmployeeApplicant.new
    @application = Bvadmin::EmployeeApplication.new
  end

  def create
    @applicant = Bvadmin::EmployeeApplicant.new

    @applicant.update applicant_params
    unless @applicant.valid?
      flash[:error] = @applicant.errors
      return render('rms/applicant/new')
    end

    @applicant.save
  end

  def locator
  end


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
