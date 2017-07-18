[
  'Telework Agreement', 'Position Description', 'Performance Appraisal',
  'Promotions', 'Performance Plan', 'Transit Benefits Application',
  'Other', 'PIP (Performance Improvement Plan)', 'SF52s (Request for Personnel Action)',
  'FMLA (Family Medical Leave Act)', 'Reasonable Accomodation',
  'Leave Without Pay (LWOP)', 'Application Documents'
].each do |doctype|
  Bvadmin::RmsDropDownConfig.create(table_id: 'ATTACHMENT',
                                    field_id: 'ATTACHMENT_TYPE',
                                    content: doctype,
                                    value: doctype,
                                    created_by: 'root@rms.config')
end
