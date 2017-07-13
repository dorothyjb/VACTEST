#! /usr/bin/env ruby

ENV['RAILS_ENV'] ||= 'test'

require '../vahs/config/environment'

if ARGV.length < 2
  puts "Usage: #$0 <email> <role>[,<role>,<role>,...]"
  exit 1
end

email = ARGV[0]
roles = ARGV[1].split(',')

user = Bvadmin::RmsUser.find_by(email: email)
unless user
  puts "Could not find that emil. (#{email})"
  exit 1
end

roles = roles.collect { |role| Bvadmin::RmsRole.find_by(name: role) }.compact
user.update rms_roles: roles

puts "User #{email} now in #{roles.map(&:name).join(', ')}"
