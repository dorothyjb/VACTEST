class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :init_session

  # Manage exceptions
  rescue_from Rms::Error::UserAuthenticationError, with: :user_authentication_error
  #rescue_from Exception, with: :generic_error

  ###
  # called when the session first starts.
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

  ###
  # a helper function for hearing reports.
  def get_hearing_type hearing_type
    result = Hash.new("")
    result['1'] = "Central Office"
    result['2'] = "Travel Board"
    result['6'] = "Video"

    result[hearing_type]
  end


  ###
  # User authentication error.
  def user_authentication_error err
    @error = err
    render template: 'errors/authentication', status: 403
  end

  ###
  # Generic exception
  def generic_error err
    @error = err
    render template: 'errors/generic', status: 500
  end
end
