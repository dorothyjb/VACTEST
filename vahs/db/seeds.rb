# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Dir[File.join(Rails.root, 'app', 'models', 'vacols', '*.rb')].each do |f|
  require f
end

Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].each do |f|
  load f
end
