class ReportsController < ApplicationController

  # Docket Range Reporting 
  def docket
    @docdate = params[:docdate]
	@hType = params[:hType]
	@rsType = params[:rsType]
  end
  def getDocket
    @docdate = params[:docdate]+"-01"
	@hType = params[:hType]
	@rsType = params[:rsType]
	@shType = getHearingType(@hType)
	
	@ttlbfDocDate = 0
	@ttls = {
		'fyCol' => [0,0,0,0,0,0],
		'ttlPending' => 0,
		'bfDocDate' => 0
	}

	begin
		@output, @ttlbfDocDate = Vacols::Brieff.get_report(@docdate, @hType, @rsType)
		
		@doTtls = JSON.parse(@output.to_json)
		@doTtls.each do |roName,obj|
			@ttls["fyCol"][0] += obj["fyCol"][0]
			@ttls["fyCol"][1] += obj["fyCol"][1]
			@ttls["fyCol"][2] += obj["fyCol"][2]
			@ttls["fyCol"][3] += obj["fyCol"][3]
			@ttls["fyCol"][4] += obj["fyCol"][4]
			@ttls["fyCol"][5] += obj["fyCol"][5]
			@ttls["ttlPending"] += obj["ttlPending"]
		end
		@ttls["bfDocDate"] = @ttlbfDocDate

		if params[:ViewResults]
			@json = JSON.parse(@output.to_json)
		else
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
	@numJudge = params[:numJudge]
	@judgeMult = params[:judgeMult]
	@coDays = params[:coDays]  
	@shType = @hType
	@judgeDays = 0
	@ttlbfDocDate = 0
	
	@ttls = {
		'ttlPending' => 0,
		'bfDocDate' => 0,
		'ttlJudgeDays' => 0,
		'ttlAdded' => 0
	}
	
	case @hType
		when "1"
			@judgeDays = 0
		when "2"
			@judgeDays = 0
		when "6"
			@judgeDays = ((((@numJudge.to_f * @judgeMult.to_f)) * 12)-12)-@coDays.to_i
  	end
		
		@output, @ttlbfDocDate = Vacols::Brieff.get_report(@docdate, @hType, 0)

		@doTtls = JSON.parse(@output.to_json)
		@doTtls.each do |roName,obj|
			@ttls["ttlPending"] += obj["ttlPending"]
		end
		@ttls["bfDocDate"] = @ttlbfDocDate
		
		if params[:ViewResults]
			@json = JSON.parse(@output.to_json)
		else
			@exportXLS = JSON.parse(@output.to_json)
			
		end

	begin
	rescue
		@err = true
	end
    render :analysis
	
  end
  
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