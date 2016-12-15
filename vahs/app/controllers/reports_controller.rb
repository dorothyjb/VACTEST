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
end