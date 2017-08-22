class Rms::ApplicantController < Rms::ApplicationController
  before_filter :verify_access
  before_filter :check_for_cancel, only: [ :create, :update ]

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
    @attachment = [Bvadmin::RmsAttachment.new]
  end

  def edit
    @applicant = Bvadmin::EmployeeApplicant.find(params[:id])
    @application = Bvadmin::EmployeeApplication.new
    @active_status = ['Pipeline', 'Incoming']
    @active_applications = Bvadmin::EmployeeApplication.active_applications(@applicant.applicant_id, @active_status)
    @attachment = [Bvadmin::RmsAttachment.new]
  rescue ActiveRecord::RecordNotFound
    flash[:error] = { 'Applicant': 'Invalid ID' }
    redirect_to rms_applicant_path
  end

  def update
    @applicant = Bvadmin::EmployeeApplicant.find(params[:id])
    @active_status = ['Pipeline', 'Incoming']
    @active_applications = Bvadmin::EmployeeApplication.active_applications(@applicant.applicant_id, @active_status)
    save_all
    
    respond_to do |format|
      if @applicant.errors.empty?
        format.html { redirect_to rms_applicant_edit_path(@applicant), notice: 'The applicant was saved successfully.' }
        format.js { 
          flash[:notice] = 'The applicant was saved successfully.'
        }
      else
        flash[:error] = @applicant.errors
        format.html { redirect_to rms_applicant_edit_path(@applicant)}
        format.js
      end
    end
  end

  def status_select
    @application = Bvadmin::EmployeeApplication.find(params[:app])
    partial = {'Denied' => 'denied', 'Incoming' => 'incoming', 'Pipeline' => 'pipeline'}.fetch(params[:partial], 'error')
    respond_to do |format|
      format.html do
        render partial: 'rms/applicant/status/' + partial, locals: {appstatus:  @application}

      end
    end
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

  def attachment_form
    respond_to do |format|
      format.html { render partial: 'rms/applicant/attachment2/upload' }
      format.js { render 'rms/applicant/attachment2/upload' }      
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

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  def save_all
    @applicant.update_attributes applicant_params
    @application = @applicant.save_applications(params[:napplication])
    @applicant.edit_applications params[:eapplication]

    @attachment = @applicant.save_attachments params[:attachment]
    @applicant.edit_attachments params[:eattachment]
    @applicant.save_attachment params[:pattachment]
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

  def check_for_cancel
    redirect_to root_path if params[:cancel]
  end

  def applicant_params
    params.require(:applicant).permit(:fname,
                                      :lname,
                                      :title,
                                      :gender,
                                      :streetadr,
                                      :city,
                                      :state,
                                      :zip,
                                      :workphone,
                                      :homephone,
                                      :cellphone,
                                      :email)
  end
end
