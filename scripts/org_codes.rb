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
    division = Bvadmin::RmsOrgDivision.find_or_create_by!(name: entry["Division"])
    branch = Bvadmin::RmsOrgBranch.find_or_create_by!(name: entry["Branch"])
    unit = Bvadmin::RmsOrgUnit.find_or_create_by!(name: entry["Unit"])

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
