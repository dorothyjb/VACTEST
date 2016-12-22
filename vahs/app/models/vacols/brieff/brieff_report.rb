class Vacols::Brieff::BrieffReport
	attr_accessor  :result, :docdate

	def initialize(docdate, hType, rsType)
		@result = Vacols::Brieff.do_work(hType, rsType)
		@docdate = docdate
	end

	def get_pending_results
		ttlbfDocDate = 0
		output = Hash.new {|h, k| h[k] = {
			'ro' => {:city=>"",:state=>"",:timezone=>""},
			'staID' => 0,
			'fyCol' => [0,0,0,0,0,0],
			'ttlPending' => 0,
			'bfDocDate' => 0,
			'tzValue' => 0
		}}

		result.each do |i|
			ro = i.get_regional_office

			output[ro]['ro'][:city] = ro
			output[ro]['staID'] = Vacols::RegionalOffice.getCSSNumber(ro)
			output[ro]['fyCol'][i.fiscal_year] +=1
			output[ro]['ttlPending'] += 1  #Total Pending regardless of DocDate
			if(i.in_docdate(docdate))
				output[ro]['bfDocDate'] += 1
				ttlbfDocDate +=1
			end
			output[ro]['tzValue'] = Vacols::RegionalOffice.tzValue(ro)
		end 

		return output, ttlbfDocDate
	end
end
