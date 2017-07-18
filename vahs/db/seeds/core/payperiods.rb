# eww
date = Date.parse('2016-12-25')
pp = 1

while date < Date.parse('2045-01-01')
  Bvadmin::Payperiod.create(payperiod: pp,
                            startdate: date,
                            enddate: date + 13.days)
  date += 2.weeks
  pp += 1
end
