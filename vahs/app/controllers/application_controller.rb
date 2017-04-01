class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :init_session

  def init_session
    #reset_session
    session[:docket_fiscal_years] ||=  [
                                         [ "1970-10-01", "2000-09-30" ],
                                         [ "2000-10-01", "2005-09-30" ],
                                         [ "2005-10-01", "2010-09-30" ],
                                         [ "2010-10-01", "2015-09-30" ],
                                         [ "2015-10-01", "2016-09-30" ],
                                         [ "2016-10-01", "2017-09-30" ],
                                       ]
  end

  def get_hearing_type hearing_type
    result = Hash.new("")
    result['1'] = "Central Office"
    result['2'] = "Travel Board"
    result['6'] = "Video"

    result[hearing_type]
  end
end
