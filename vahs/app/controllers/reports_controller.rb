class ReportsController < ApplicationController
  def home
    @docdate = params[:docdate]
	@hType = params[:hType]
	@rsType = params[:rsType]
  end

  def create
    @docdate = params[:docdate]+"-01"
	@hType = params[:hType]
	@rsType = params[:rsType]
	@shType = ""
	@ttlPending = 0
	
	case @hType
  	when "1"
  		@shType = "Central Office"
  	when "2"
		@shType = "Travel Board"
  	when "6"
  		@shType = "Video"
  	end
	
	begin
		@result = Vacols::Brieff.do_work(@docdate, @hType, @rsType)
		@output = Hash.new {|h, k| h[k] = [0,0,0,0,0,0,0]}
		@result.each do |i|
			@output[i["BFREGOFF"]][i.fiscal_year] +=1
			@output[i["BFREGOFF"]][6] += 1
			@ttlPending +=1
		end 
		
		if params[:ViewResults]
			@json = JSON.parse(@output.to_json)
		else
			@exportXLS = JSON.parse(@output.to_json)
		end
	rescue
		@err = true
	end
	render :home
  end
end@rsType)
		
		#Parse the data to a JSON object and sum up the FY columns for the Totals row
		@doTtls = JSON.parse(@output.to_json)
		@doTtls.each do |roName,obj|
			@ttls["fyCol"][0] += obj["fyCol"][0]
			@ttls["fyCol"][1] += obj["fyCol"][1]
			@ttls["fyCol"][2] += obj["fyCol"][2]
			@ttls["fyCol"][3] += obj["fyCol"][3]
			@ttls["fyCol"][4] += obj["fyCol"][4]
			@ttls["fyCol"][5] += obj["fyCol"][5]
		end

		#Partials execute based on what 'exists'
		if params[:ViewResults]
			#User clicked the View Results button
			@json = JSON.parse(@output.to_json)
		else
			#User clicked the View Results button
			@exportXLS = JSON.parse(@output.to_json)
		end
	rescue
		@err = true
	end
	render :docket
  end

  # Docket FY Analysis Reporting 
  def analysis
    @docdate = params[:docdate]
	@hType = params[:hType]
	@numJudge = params[:numJudge]
	@judgeMult = params[:judgeMult]
	@coDays = params[:coDays]  
  end
  def getAnalysis
    @docdate = params[:docdate]+"-01"
	@hType = params[:hType]
	@shType = @hType
	
	#Temporary Hack to get values from the form
	# - The form fields will be replaced once an analysis 
	#   parameters configuration page is implemented
	@numJudge = params[:numJudge]
	@judgeMult = params[:judgeMult]
	@coDays = params[:coDays]  
	@judgeDays = 0  #Calculated Judge Days for Video Hearings Analysis
	
	#Object to hold totals
	# - bfDocDate: total of the records that are before Docket Date (bfDocDate)
	# - ttlPending: total of all returned records
	# - ttlJudgeDays: total of all RO's Judge days
	# - ttlAdded: total of all days add by RO Juedge Day calculations 
	@ttls = {
		'bfDocDate' => 0,
		'ttlPending' => 0,
		'ttlJudgeDays' => 0,
		'ttlAdded' => 0
	}
	
	#Case to determine what calculations need to be done for the appropriate requested analysis
	case @hType
		when "1"
			@judgeDays = @coDays.to_i - 3 #need to look into this minus 3
		when "2"
			@judgeDays = 0
		when "6"
			# The additional subtraction of 12 is because of ??? Holidays ???
			# Excel Example: 1331 = ((( 57 * 2.25 ) * 12 ) - 12 ) - 196 
			@judgeDays = (((@numJudge.to_f * @judgeMult.to_f) * 12))-@coDays.to_i
  	end
	
	begin		
		#Get the data 
		@output, @ttls["bfDocDate"], @ttls["ttlPending"] = Vacols::Brieff.get_report(@docdate, @hType, 0)
				
		#Partials execute based on what 'exists'
		if params[:ViewResults]
			#User clicked the View Results button
			@json = JSON.parse(@output.to_json)
		else
			#User clicked the View Results button
			@exportXLS = JSON.parse(@output.to_json)
		end
	rescue
		@err = true
	end
    render :analysis
  end

  #Function for returning the string for the type of hearing selected
  def getHearingType(hType)
  	case hType
		when "1"
			return "Central Office"
		when "2"
			return "Travel Board"
		when "6"
			return "Video"
		else
			return ""
  	end
 end
end