class Vacols::Brieff::BrieffReport
	attr_accessor  :result, :docdate

	def initialize(docdate, hType, rsType)
		@result = Vacols::Brieff.do_work(hType, rsType)
		@docdate = docdate
	end

	def get_pending_results
		ttlbfDocDate = 0
		output = Hash.new {|h, k| h[k] = {
			'fyCol' => [0,0,0,0,0,0],
			'ttlPending' => 0,
			'bfDocDate' => 0
		}}

		result.each do |i|
			output[i.get_regional_office]['fyCol'][i.fiscal_year] +=1
			output[i.get_regional_office]['ttlPending'] += 1  #Total Pending regardless of DocDate
			if(i.in_docdate(docdate))
				output[i.get_regional_office]['bfDocDate'] += 1
				ttlbfDocDate +=1
			end
		end 

		return output, ttlbfDocDate
	end
end