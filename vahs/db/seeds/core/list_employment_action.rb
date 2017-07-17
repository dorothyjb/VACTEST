[ 'Appointment', 'Seperation', 'Promotion' ].each do |emp_action|
  Bvadmin::RmsDropDownConfig.create(table_id: 'EMPLOYEE',
                                    field_id: 'EMPLOYMENT_ACTION',
                                    content: emp_action,
                                    value: emp_action,
                                    created_by: 'root@rms.config')
end
