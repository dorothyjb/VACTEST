class Bvadmin::Payperiod < Bvadmin::Record
  self.table_name = "BVADMIN.PAYPERIODS"


#get current payperiod
scope :cur_pp, -> {where("startdate <= :cur_date and enddate >= :cur_date", {cur_date: Date.today} )}  

#get next payperiod
scope :next_pp, -> {where("startdate <= :next_date and enddate >= :next_date", {next_date: Date.today+2.weeks} )}  

end

