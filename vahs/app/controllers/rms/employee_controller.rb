class Rms::EmployeeController < Rms::ApplicationController
  before_filter :verify_access, except: [ :locator, :picture ]
  before_filter :check_for_cancel, only: [ :create, :update ]

  rescue_from ActiveRecord::RecordNotFound, with: :employee_not_found

  def new
    @employee = Bvadmin::Employee.new
    @attorney = Bvadmin::Attorney.new
    @org_code = Bvadmin::RmsOrgCode.new
    @org_code_2 = Bvadmin::RmsOrgCode.new
  end

  def create
    @employee = Bvadmin::Employee.new

    @employee.update employee_params
    unless @employee.valid?
      flash[:error] = @employee.errors
      return render('rms/employee/new')
    end

    @employee.save

    # XXX: Works around a bug.
    # Believe there is a trigger in the DB that is causing this behavior.
    @employee.employee_id += 1
    @employee.reload

    @employee.update_attorney(attorney_params)
    @employee.update_picture(params[:employee_pic])

    @employee.primary_org = params[:primary_org]
    @employee.rotation_org = params[:rotation_org]

    @employee.save_attachment attachment_params

    @employee.add_training training_params

    if @employee.valid?
      @employee.save
      redirect_to rms_employee_edit_path(@employee), notice: 'The employee was updated successfully.'
    else
      flash[:error] = @employee.errors
      render 'rms/employee/edit'
    end
  end

  def edit
    @employee = Bvadmin::Employee.find(params[:id])
    @training = Bvadmin::Training.find_by(user_id: @employee.user_id)||Bvadmin::Training.new


  rescue Exception
    flash[:error] = { employee: 'Invalid ID' }
    redirect_to rms_employee_new_path
  end

  def update
    @employee = Bvadmin::Employee.find(params[:id])
    @employee.update_attributes!(employee_params)
    @employee.update_attorney!(attorney_params)
    @employee.primary_org = params[:primary_org]
    @employee.rotation_org = params[:rotation_org]
    @employee.update_picture(params[:employee_pic])
    @employee.save_attachment attachment_params
    @employee.add_training training_params

    respond_to do |format|
      format.html { redirect_to rms_employee_edit_path(@employee), notice: 'The employee was saved successfully.' }
      format.js { 
        flash[:notice] = 'The employee was saved successfully.'
        render 'rms/employee/success'
      }
    end

  rescue Exception
    flash[:error] = @employee.errors rescue { employee: 'Invalid ID' }
    respond_to do |format|
      format.html { render 'rms/employee/edit' }
      format.js { render 'rms/employee/errors' }
    end
  end

  def locator
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

  def picture
    @employee = Bvadmin::Employee.find(params[:id])

    if @employee.has_picture?
      send_data @employee.picture_data, type: @employee.picture_mime
    else
      redirect_to "/assets/no-employee-pic.png"
    end

  rescue
    redirect_to "/assets/no-employee-pic.png"
  end

  private

  def check_for_cancel
    redirect_to root_path if params[:cancel]
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

  def training_params
    params.require(:training).permit(:user_id,
                                     :class_name,
                                     :class_date)
  end

  def attorney_params
    # All of these are pulled from grade/positions tab.
    params.require(:attorney).permit(:bar_member,
                                     :board_appt_date,
                                     :board_exp_date,
                                     :board_reappt_date,
                                     :notes,
                                     :license,
                                     :jurisdiction,
                                     :lawschool,
                                     :attorney_notes)
  end

  def employee_params
    params.require(:employee).permit(# personal page 1
                                     :attorney_id,
                                     :user_id,
                                     :login_id,
                                     :lname,
                                     :fname,
                                     :mi,
                                     :sub_title,
                                     :bva_title,
                                     :work_group,
                                     :hrsmart_id,
                                     :blding_room,
                                     # personal page 2
                                     :prev_lname,
                                     :ssn,
                                     :gender,
                                     :pob_city,
                                     :pob_state,
                                     :pob_country,
                                     :duty_status,
                                     :service,
                                     :eom,
                                     :vet_status,
                                     :military_service_branch,
                                     :current_bva_duty_date,
                                     :prior_bva_duty_date,
                                     :position_detail,
                                     # grade/position
                                     :supervisor,
                                     :paid_title,
                                     :job_code,
                                     :pay_sched,
                                     :date_of_grade,
                                     :promo_elig_date,
                                     :fte,
                                     :wig_date,
                                     :last_wig_date,
                                     :rotation_start,
                                     :rotation_end
                                    )
  end

  def attachment_params
    params.require(:attachment).permit(:attachment_type,
                                       :attachment,
                                       :notes)
  end

  def employee_not_found
    render template: 'errors/employee_not_found'
  end
end
