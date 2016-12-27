class Vacols::Brieff::BrieffReport
	attr_accessor  :result, :docdate

	def initialize(docdate, hType, rsType)
		#Get the db results based on the parameters provided - Central Office, Travel Board, or Video Hearings
		@result = Vacols::Brieff.do_work(hType, rsType)
		@docdate = docdate
	end

	def get_pending_results
	
		#Variable to hold the Total Number of Docket entries that occur before the Docket date selected
		ttlbfDocDate = 0
		
		#Hash Object that contains a compiled result on each Regional Office for use in reporting
		output = Hash.new {|h, k| h[k] = {
			'ro' => {},
			'staID' => 0,
			'fyCol' => [0,0,0,0,0,0],
			'ttlPending' => 0,
			'bfDocDate' => 0,
			'tzValue' => 0
		}}

		#Loop through each result of the query and compile the information about each Regional Office
		result.each do |i|
			roID = i.get_regional_office
			
			#roInfo returns the StationID, 
			# Regional Office info (City, State, TimeZone),
			# and TimeZone value used for the Video Hearing Analysis Calculations
			output[roID]['staID'], output[roID]['ro'] , output[roID]['tzValue'] = Vacols::RegionalOffice.roInfo(roID)
			
			#Calculate the Fiscal Year and increment the appropriate FY column
			output[roID]['fyCol'][i.fiscal_year] +=1
			
			#Total Pending regardless of DocDate
			output[roID]['ttlPending'] += 1
			
			#Calculate the quantity of entries that exist before the Docket date value
			if(i.in_docdate(docdate))
				output[roID]['bfDocDate'] += 1
				ttlbfDocDate +=1
			end
		end 

		return output, ttlbfDocDate
	end
end
