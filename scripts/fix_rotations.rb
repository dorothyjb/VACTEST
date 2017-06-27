#! /usr/bin/env ruby

require '../vahs/config/environment'

Bvadmin::RmsOrgCode.all.each do |o|
  if o.code =~ /.+R$/
    puts "#{o.code} is a rotation"
    o.rotation = true
    if o.save
      puts "-> #{o.code} updated."
    end
  else
    puts "#{o.code} is not a rotation"
    o.rotation = false
    if o.save
      puts "-> #{o.code} updated."
    end
  end
end
