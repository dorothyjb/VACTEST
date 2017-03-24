class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :init_session

  def init_session
    #reset_session
    session[:docket_fiscal_years] ||=  [
                                         [ "1970-09-30", "2000-09-30" ],
                                         [ "2001-09-30", "2005-09-30" ],
                                         [ "2006-09-30", "2010-09-30" ],
                                         [ "2011-09-30", "2015-09-30" ],
                                         [ "2016-09-30", "2017-09-30" ],
                                         [ "2017-09-30", "2018-09-30" ],
                                       ]
  end
end
