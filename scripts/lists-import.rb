#! /usr/bin/env ruby

require '../vahs/config/environment'

Vacols::Lists.employee.each do |le|
  puts <<EOF
Bvadmin::RmsDropDownConfig.create(table_id: '#{le.lstkey}', field_id: '#{le.lststfid}', content: '#{le.lstactcd}', value: '#{le.lstactcd}', created_by: 'root@rms.config')
EOF
end
