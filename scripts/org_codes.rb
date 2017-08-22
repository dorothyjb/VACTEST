#! /usr/bin/env ruby

require 'csv'
require '../vahs/config/environment'

roster = CSV.open("roster.csv", headers: true, encoding: "UTF-8")
roster.each do |entry|
  next if entry.nil?
  next if entry["Org Code"].nil?

  begin
    puts "Inserting #{entry["Org Code"]}"

    office = Bvadmin::RmsOrgOffice.find_or_create_by!(name: entry["Office"])
    division = Bvadmin::RmsOrgDivision.find_or_create_by!(name: entry["Division"], parent_id: office.id)
    branch = Bvadmin::RmsOrgBranch.find_or_create_by!(name: entry["Branch"], parent_id: division.id)
    unit = Bvadmin::RmsOrgUnit.find_or_create_by!(name: entry["Unit"], parent_id: branch.id)

    Bvadmin::RmsOrgCode.create!(code: entry["Org Code"],
                                office_id: office.id,
                                division_id: division.id,
                                branch_id: branch.id,
                                unit_id: unit.id)
  rescue => e
    puts "Failed to create #{entry["Org Code"]} -- #{e}"
    exit 1
  end
end

# CSV.each pops the array?
roster = CSV.open("roster.csv", headers: true, encoding: "UTF-8")
roster.each do |entry|
  next if entry.nil?
  next if entry["Org Code"].nil?
  next if entry["Position Occupant "].nil?

  name = entry["Position Occupant "].split(/, /)
  if name.length == 2
    last, first = name
    e = Bvadmin::Employee.find_by(lname: last.upcase, fname: first.upcase)
    if e.nil?
      puts "Skipping \"#{last}, #{first}\"."
      next
    end

    o = Bvadmin::RmsOrgCode.find_by(code: entry["Org Code"])
    if o.nil?
      puts "Skipping \"#{entry["Org Code"]}\""
      next
    end

    puts "Attempting to link #{e.employee_id} <> #{entry["Org Code"]}"
    if entry["Rotation"].to_i == 0
      e.primary_org = o.id
      puts " -- primary"
    else
      e.rotation_org = o.id
      puts " -- rotation"
    end
  end
end
