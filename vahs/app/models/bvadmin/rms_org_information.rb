class Bvadmin::RmsOrgInformation < Bvadmin::Record
  self.table_name = "BVADMIN.RMS_ORG_INFORMATION"

  belongs_to :rms_org_code

  def self.dropdown
    [ '' ] + where('name is not null').collect { |n| [ n[:name], n[:id] ] }
  end

  def total_fte
    sql, vars = get_applied_filters_for(:employee)

    Bvadmin::Employee.joins(join_query).where(<<-EOQ, vars).sum(:fte).to_f
      rms_org_code.#{type_id} = #{self.id} and employee.fte > 0
      #{sql}
    EOQ
  end

  def total_employees
    sql, vars = get_applied_filters_for(:employee)

    Bvadmin::Employee.joins(join_query).where(<<-EOQ, vars).count
      rms_org_code.#{type_id} = #{self.id} and
      employee.fte > 0
      #{sql}
    EOQ
  end

  def total_vacant
    Bvadmin::RmsOrgCode.where("employee_id is null and #{type_id} = #{self.id}").count
  end

  def total_on_board
    sql, vars = get_applied_filters_for(:employee)

    Bvadmin::Employee.joins(join_query).where(<<-EOQ, vars).count
      rms_org_code.#{type_id} = #{self.id} and
      employee.fte > 0 and
      employee.on_union = 0 and (
        rms_employee_assignment_info.other_assignment is null or
        rms_employee_assignment_info.other_assignment not in ('Detail To', 'Extended Leave')
      )
      #{sql}
    EOQ
  end

  def total_on_board_other
    sql, vars = get_applied_filters_for(:employee)

    Bvadmin::Employee.joins(join_query).where(<<-EOQ, vars).count
      rms_org_code.#{type_id} = #{self.id} and
      employee.fte > 0 and (
        employee.on_union = 1 or (
          rms_employee_assignment_info.other_assignment is not null and
          rms_employee_assignment_info.other_assignment in ('Detail To', 'Extended Leave')
        )
      )
      #{sql}
    EOQ
  end

  def total_rotation
    sql, vars = get_applied_filters_for(:employee)

    Bvadmin::Employee.joins(join_query).where(<<-EOQ, vars).count
      rms_org_code.#{type_id} = #{self.id} and
      employee.fte > 0 and
      rms_org_code.rotation = 1
      #{sql}
    EOQ
  end

  def funded_positions
    sql, vars = get_applied_filters_for(:employee)

    Bvadmin::RmsOrgCode.joins(:employee).where(<<-EOQ, vars).count
      rms_org_code.#{type_id} = #{self.id} and
      rms_org_code.rotation = 0
      #{sql}
    EOQ
  end

  def unfunded_positions
    sql, vars = get_applied_filters_for(:employee)

    Bvadmin::RmsOrgCode.joins(:employee).where(<<-EOQ, vars).count
      rms_org_code.#{type_id} = #{self.id} and
      rms_org_code.rotation = 1
      #{sql}
    EOQ
  end

  def total_incoming
    sql, vars = get_applied_filters_for(:applicant)

    Bvadmin::EmployeeApplicant.joins(:applications).where(<<-EOQ, vars).count
      employee_applications.#{type_id} = #{self.id} and
      employee_applications.status = 'INCOMING' and
      employee_applications.confirmed_eod >= SYSDATE
      #{sql}
    EOQ
  end

  def total_departing
    sql, vars = get_applied_filters_for(:employee)

    Bvadmin::Employee.joins(:org_codes, :statuses).where(<<-EOQ, vars).count
      rms_org_code.#{type_id} = #{self.id} and
      employee.fte > 0 and
      rms_status_info.status_type = 'Seperation' and
      SYSDATE < rms_status_info.seperation_effective_date
      #{sql}
    EOQ
  end

  def filters= filters
    @filters = filters
  end

private
  def get_applied_filters_for type
    {
      employee: get_applied_filters_employee,
      applicant: get_applied_filters_applicant,
    }.fetch(type, [ '', {} ])
  end
  
  def get_applied_filters_applicant
    @filters ||= {}

    filter_vars = {}
    sql = ""

    if @filters[:official_titles]
      sql += "and (employee_applications.title in (:official_titles)) "
      filter_vars[:official_titles] = @filters[:official_titles]
    end

    if @filters[:series]
      sql += "and (employee_applicants.series in (:series)) "
      filter_vars[:series] = @filters[:series]
    end

    if @filters[:grades]
      sql += "and (employee_applicants.grade in (:grades)) "
      filter_vars[:grades] = @filters[:grades]
    end

    if @filters[:eod_start].present?
      sql += "and (employee_applications.confirmed_eod >= :eod_start) "
      filter_vars[:eod_start] = parse_date(@filters[:eod_start])
    end

    if @filters[:eod_end].present?
      sql += "and (employee_applications.confirmed_eod <= :eod_end) "
      filter_vars[:eod_end] = parse_date(@filters[:eod_end])
    end

    if @filters[:status]
      # TODO
    end

    [ sql, filter_vars ]
  end

  def get_applied_filters_employee
    @filters ||= {}

    filter_vars = {}
    sql = ""

    if @filters[:official_titles]
      sql += "and (employee.paid_title in (:official_titles)) "
      filter_vars[:official_titles] = @filters[:official_titles]
    end

    if @filters[:unofficial_titles]
      sql += "and (employee.bva_title in (:unofficial_titles)) "
      filter_vars[:unofficial_titles] = @filters[:unofficial_titles]
    end

    if @filters[:series]
      sql += "and (employee.job_code in (:series)) "
      filter_vars[:series] = @filters[:series]
    end

    if @filters[:grades]
      sql += "and (employee.grade in (:grades)) "
      filter_vars[:grades] = @filters[:grades]
    end

    if @filters[:eod_start].present?
      sql += "and (employee.current_bva_duty_date >= :eod_start) "
      filter_vars[:eod_start] = parse_date(@filters[:eod_start])
    end

    if @filters[:eod_end].present?
      sql += "and (employee.current_bva_duty_date <= :eod_end) "
      filter_vars[:eod_end] = parse_date(@filters[:eod_end])
    end

    if @filters[:status]
      # TODO
    end

    [ sql, filter_vars ]
  end

  def join_query
    <<-EOJ
      JOIN "BVADMIN"."RMS_ORG_CODE" ON
        "BVADMIN"."RMS_ORG_CODE"."EMPLOYEE_ID" = "BVADMIN"."EMPLOYEE"."EMPLOYEE_ID"

      LEFT JOIN "BVADMIN"."RMS_EMPLOYEE_ASSIGNMENT_INFO" ON
        "BVADMIN"."RMS_EMPLOYEE_ASSIGNMENT_INFO"."EMPLOYEE_ID" = "BVADMIN"."EMPLOYEE"."EMPLOYEE_ID"

      LEFT JOIN "BVADMIN"."RMS_STATUS_INFO" ON
        "BVADMIN"."RMS_STATUS_INFO"."EMPLOYEE_ID" = "BVADMIN"."EMPLOYEE"."EMPLOYEE_ID"
    EOJ
  end

  def type_id
    {
      'Bvadmin::RmsOrgOffice' => 'office_id',
      'Bvadmin::RmsOrgDivision' => 'division_id',
      'Bvadmin::RmsOrgBranch' => 'branch_id',
      'Bvadmin::RmsOrgUnit' => 'unit_id',
    }.fetch(self.class.to_s, 'id')
  end

  def parse_date in_date
    out_date = ''

    if %r{^(?<month>\d{2})(?<day>\d{2})(?<year>\d{4,})|
           (?<month>\d{1,2})/(?<day>\d{1,2})/(?<year>\d{4,})|
           (?<year>\d{4,})-(?<month>\d{1,2})-(?<day>\d{1,2})$}x =~ in_date

      out_date = begin
                   Date.new(year.to_i, month.to_i, day.to_i)
                 rescue ArgumentError
                   ''
                 end
    end

    out_date
  end
end
