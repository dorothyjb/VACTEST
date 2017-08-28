[ 'Departing', 'Departed', 'Notes' ].each do |sep_status|
  Bvadmin::RmsDropDownConfig.create(table_id: 'EMPLOYEE',
                                    field_id: 'SEPARATION_STATUS',
                                    content: sep_status,
                                    value: sep_status,
                                    created_by: 'root@rms.config')
end

[ 
  'Resignation', 'Termination', 'Retirement', 
  'Transfer', 'Other'
].each do |sep_reason|
  Bvadmin::RmsDropDownConfig.create(table_id: 'EMPLOYEE',
                                    field_id: 'SEPARATION_REASON',
                                    content: sep_reason,
                                    value: sep_reason,
                                    created_by: 'root@rms.config')
end
