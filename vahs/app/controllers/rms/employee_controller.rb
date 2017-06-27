class Rms::EmployeeController < Rms::ApplicationController
  before_filter :verify_access, except: [ :locator, :picture ]
  before_filter :check_for_cancel, only: [ :new, :edit ]

  rescue_from ActiveRecord::RecordNotFound, with: :employee_not_found

  def new
    if params[:save]
      @employee = Bvadmin::Employee.create!(employee_params)

      # This is to work around a bug right now. need to fix.
      @employee.employee_id += 1
      @employee.reload

      @attorney = Bvadmin::Attorney.create!(attorney_params.merge(employee_id: @employee.id))
      @employee.save_picture params[:employee_pic] if params[:employee_pic]

      flash[:notice] = "The employee \"#{@employee.lname}, #{@employee.fname}\" was created successfully."

      params.delete(:save)
      params.delete(:employee)

      redirect_to rms_employee_edit_path(@employee)
    else
      @employee = Bvadmin::Employee.new
      @attorney = Bvadmin::Attorney.new
    end

  rescue ActiveRecord::RecordInvalid => e
    @employee = Bvadmin::Employee.new(employee_params)
    flash[:notice] = "Please ensure the required fields have been filled out."

  rescue ActiveRecord::RecordNotUnique => e
    @employee = Bvadmin::Employee.new(employee_params)
    flash[:notice] = "#{e.message}"
  end

  def edit
    @employee = Bvadmin::Employee.find(params[:id])
    @attorney = @employee.attorney || Bvadmin::Attorney.new
    @org_code = Bvadmin::RmsOrgCode.find_by(employee_id: @employee.employee_id, rotation: false) || Bvadmin::RmsOrgCode.new
    @org_code_2 = Bvadmin::RmsOrgCode.find_by(employee_id: @employee.employee_id, rotation: true) || Bvadmin::RmsOrgCode.new

    if params[:save]
      @employee.update! employee_params
      @employee.save_picture params[:employee_pic] if params[:employee_pic]
      @attorney.update! attorney_params.merge(employee_id: @employee.employee_id, attorney_id: @employee.attorney_id)

      if params[:org_code]
        @org_code = @employee.update_org(params[:org_code])
      else
        @employee.remove_org
      end

      if params[:org_code_2]
        @org_code_2 = @employee.update_org(params[:org_code_2], true)
      else
        @employee.remove_org true
      end

      flash[:notice] = "Employee \"#{@employee.lname}, #{@employee.fname}\" was updated successfully."
    end

  rescue ActiveRecord::RecordInvalid => e
    flash[:notice] = "Please ensure the required fields have been filled out."

  rescue ActiveRecord::RecordNotUnique => e
    field = $1 if e.message =~ /^.*SET "(.+)" = :a1.*$/
    flash[:notice] = "Duplicate value not allowed for #{field}."
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

  def employee_not_found
    render template: 'errors/employee_not_found'
  end
end
