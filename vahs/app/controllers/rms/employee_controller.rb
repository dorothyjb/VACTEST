class Rms::EmployeeController < Rms::ApplicationController
  before_filter :verify_access, except: [ :locator, :picture ]
  before_filter :check_for_cancel, only: [ :create, :update ]

  rescue_from ActiveRecord::RecordNotFound, with: :employee_not_found

  def new
    @employee = Bvadmin::Employee.new
    @employee.build_attorney if @employee.attorney.nil?
    @employee.build_assignment if @employee.assignment.nil?
    @training = Bvadmin::Training.new
    @award = [Bvadmin::EmployeeAwardInfo.new]
    @empstatus = Bvadmin::RmsStatusInfo.new
    @attachment = [Bvadmin::RmsAttachment.new]
  end

  def create
    @employee = Bvadmin::Employee.new
    @training = Bvadmin::Training.new
    @award = [Bvadmin::EmployeeAwardInfo.new]
    @empstatus = Bvadmin::RmsStatusInfo.new
    @attachment = [Bvadmin::RmsAttachment.new]

    @employee.update employee_params
    unless @employee.valid?
      @employee.build_attorney if @employee.attorney.nil?
      @employee.build_assignment if @employee.assignment.nil?
      flash[:error] = @employee.errors
      return render('rms/employee/new')
    end

    @employee.save

    # XXX: Works around a bug.
    # Believe there is a trigger in the DB that is causing this behavior.
    @employee.employee_id += 1
    @employee.reload

    save_all

    if @employee.errors.empty?
      @employee.save
      redirect_to rms_employee_edit_path(@employee, current_tab: params[:current_tab]),
                  notice: 'The employee was updated successfully.'
    else
      @employee.build_attorney if @employee.attorney.nil?
      @employee.build_assignment if @employee.assignment.nil?
      flash[:error] = @employee.errors
      render 'rms/employee/edit'
    end
  end

  def edit
    @employee = Bvadmin::Employee.find(params[:id])
    @employee.build_attorney if @employee.attorney.nil?
    @employee.build_assignment if @employee.assignment.nil?
    @training = Bvadmin::Training.new
    @award = [Bvadmin::EmployeeAwardInfo.new]
    @empstatus = Bvadmin::RmsStatusInfo.new
    @attachment = [Bvadmin::RmsAttachment.new]

  rescue Exception
    flash[:error] = { employee: 'Invalid ID' }
    redirect_to rms_employee_new_path
  end

  def update
    @employee = Bvadmin::Employee.find(params[:id])

    if params[:delete]
      @employee.fte = 0
      @employee.save

      return redirect_to(root_path, notice: 'Employee was deleted')
    else
      save_all
    end
    
    respond_to do |format|
      if @employee.errors.empty?
        format.html { redirect_to rms_employee_edit_path(@employee, current_tab: params[:current_tab]),
                      notice: 'The employee was saved successfully.' }
        format.js { 
          flash[:notice] = 'The employee was saved successfully.'
          render 'rms/employee/success'
        }
      else
        flash[:error] = @employee.errors
        format.html { render 'rms/employee/edit' }
        format.js { render 'rms/employee/errors' }
      end
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = { employee: 'Invalid ID' }
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
  
  def schedule_select
    @employee = Bvadmin::Employee.find(params[:emp])
    @employee.build_assignment if @employee.assignment.nil?

    partial = {'Satellite Station' => 'satellite', 'Telework' => 'telework', 'Primary Station' => 'primary', 'Other' => 'other'}.fetch(params[:partial], 'error')
    respond_to do |format|
      format.html do
        render partial: 'rms/employee/schedule/' + partial, employee: @employee
      end
    end
  end
  def status_select
    @employee = Bvadmin::Employee.find(params[:emp])
    @empstatus = Bvadmin::RmsStatusInfo.new
    partial = {'Appointment' => 'appointment', 'Separation' => 'separation', 'Promotion' => 'promotion'}.fetch(params[:partial], 'error')
    respond_to do |format|
      format.html do
        render partial: 'rms/employee/status/' + partial, employee: @employee
      end
    end
  end

  def award_form
    respond_to do |format|
      format.html { render partial: 'rms/employee/award/upload' }
      format.js { render 'rms/employee/award/upload' }      
    end
  end
  
  def attachment_form
    respond_to do |format|
      format.html { render partial: 'rms/employee/attachment/upload' }
      format.js { render 'rms/employee/attachment/upload' }      
    end
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

  def save_all
    @employee.update_attributes employee_params
    @employee.update_attorney attorney_params

    @employee.primary_org = params[:primary_org]

    if params[:on_rotation]
      @employee.rotation_org = params[:rotation_org]
    else
      @employee.rotation_org = nil
    end

    @employee.update_picture params[:employee_pic]

    @attachment = @employee.save_attachments params[:attachment]
    @employee.edit_attachments params[:eattachment]
    @employee.save_attachment params[:pattachment]

    @award = @employee.save_awards(params[:award])
    @employee.edit_awards params[:eaward]

    @training = @employee.save_training(training_params)
    @employee.update_training params[:etraining]

    @empstatus = @employee.save_status(status_params)
    @employee.update_assignment assignment_params
 end

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
    params.require(:training).permit(:class_name,
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
                                     :attorney_notes,
                                     :presidential_admin)
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
                                     :rotation_end,
                                     #schedule
                                     :comp_wk_sched,
                                     :mon1,
                                     :mon2,
                                     :tues1,
                                     :tues2,
                                     :wed1,
                                     :wed2,
                                     :thur1,
                                     :thur2,
                                     :fri1,
                                     :fri2,
                                     :on_union,
                                     :union_start,
                                     :union_end,
                                     :union_timespent,
                                     # poc
                                     :street,
                                     :city,
                                     :state,
                                     :zip,
                                     :work_phone,
                                     :cell_phone,
                                     :email_address,
                                     :poc_name,
                                     :poc_relation,
                                     :pos_street,
                                     :poc_city,
                                     :poc_state,
                                     :poc_zip,
                                     :poc_work_phone,
                                     :poc_home_phone,
                                     :poc_cell_phone,
                                     :poc_notes,
                                     :poc_email_address
                                    )
  end

  def assignment_params
    params.require(:assignment).permit(:assignment_type,
                                       :telework_type,
                                       :telework_street,
                                       :telework_city,
                                       :telework_state,
                                       :telework_zip,
                                       :room_number,
                                       :primary_station,
                                       :satellite_station,
                                       :other_assignment,
                                       :effective_date,
                                       :location_detailed,
                                       :expected_return_date,
                                       :reason_for_leave,
                                       :leave_period,
                                       :leave_contact_info,
                                       :loc_m1,
                                       :loc_m2,
                                       :loc_tu1,
                                       :loc_tu2,
                                       :loc_w1,
                                       :loc_w2,
                                       :loc_th1,
                                       :loc_th2,
                                       :loc_f1,
                                       :loc_f2,
                                       :satellite_room
                                       )
  end
  def attachment_params
    params.require(:attachment).permit(:attachment_type,
                                       :attachment,
                                       :notes)
  end

  def status_params
    params.require(:status).permit(:status_type,
                                   :rolls_date,
                                   :appointment_onboard_date,
                                   :appointment_notes,
                                   :promotion_date,
                                   :promotion_notes,
                                   :separation_status,
                                   :separation_effective_date,
                                   :separation_reason,
                                   :termination_notes)                                
  end
  
  def employee_not_found
    render template: 'errors/employee_not_found'
  end
end
