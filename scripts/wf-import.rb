#! /usr/bin/env ruby

require 'csv'
require '../vahs/config/environment'

master = CSV.open('master.csv', headers: true)
total = 0
found = 0
places = []
entries = []

master.each do |row|
  total += 1
  first_last = row['Position Occupant']
  next if first_last.nil?

  lname, fname = first_last.split(/, /)
  next if lname.nil? or fname.nil?

  places << [ row['Office'], row['Division'], row['Branch'] ]

  emp = Bvadmin::Employee.where('LOWER(fname) = ? AND LOWER(lname) = ?', fname.downcase, lname.downcase)
  next if emp.nil? or emp.size == 0

  entries << {
    data: row,
    fname: fname,
    lname: lname,
    employee: emp.first,
  }

  found += 1
end

puts "#{found}/#{total}"
puts "Populating org_info"

places.uniq.each do |plc|
  next if Bvadmin::OrgInfo.exists?(office: plc[0], division: plc[1], branch: plc[2])

  oi = Bvadmin::OrgInfo.new
  oi.id = Bvadmin::OrgInfo.maximum(:id).next rescue 1
  oi.office = plc[0]
  oi.division = plc[1]
  oi.branch = plc[2]
  oi.save
end

puts "Processing #{entries.length} entries."
i = 0
entries.each do |ent|
  next if Bvadmin::OrgPosition.exists?(employee_id: ent[:employee].employee_id)

  inf = Bvadmin::OrgInfo.find_by(office: ent[:data]['Office'], division: ent[:data]['Division'], branch: ent[:data]['Branch'])
  next if inf.nil?

  i += 1
  puts "Adding #{ent[:lname]}, #{ent[:fname]} #{i}/#{entries.length}"

  org_code = ent[:data]['Org Code'].split('*').first

  pos = Bvadmin::OrgPosition.new
  pos.id = Bvadmin::OrgPosition.maximum(:id).next rescue 1
  pos.org_info_id = inf.id
  pos.employee_id = ent[:employee].employee_id
  pos.org_code = org_code
  pos.position_type = ent[:data]['Perm Position'] == "1" ? "PERMANENT" : "ROTATION"
  pos.last_update = Date.today
  pos.save
end
