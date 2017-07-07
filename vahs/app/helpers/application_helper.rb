module ApplicationHelper
  def title(page_title)
    content_for :title, page_title.to_s
  end

  def page_header header
    content_for :page_header, header.to_s
  end

  def nav_class page
    klass = "nav-item nav-link"
    klass += " active" if current_action?(page)
    klass
  end

  def subnav_class page
    klass = "subnav-item subnav-link"
    klass += " subnav-active" if current_action?(page)
    klass
  end

  def dsp_date dt
    return dt if dt.nil?

    dt.strftime("%m/%d/%Y")
  end

  def current_action? page
    return false if page.nil? or page.index('#').nil?

    controller, action = page.split('#')
    controller == params[:controller] && (action == '*' or action == params[:action])
  end

  def auth_link_to *args
    link_to *args
  end

  def auth_content_for *roles, &block
    rst = ""
    rst = capture(&block) if current_user.has_role? *roles
    rst
  end

  def current_subject
    cert = request.headers['SSL_CLIENT_CERT']
    cert ||= request.headers['rack.peer_cert']

    OpenSSL::X509::Certificate.new(cert).subject.to_s
  rescue
    # The test@localhost user when Rails.env == 'test'
    { "test" => "UID=test@localhost" }.fetch(Rails.env, "")
  end

  def current_user
    @user ||= begin
      subj = current_subject
      raise Rms::Error::UserAuthenticationError, "User did not provide a certificate" if subj.empty?

      # eww; pretty sure there is a cleaner way.
      email = subj.split('/').delete_if { |s| !(s =~ /^UID=(.*)$/) }.first
      raise Rms::Error::UserAuthenticationError, "User did not provide the necessary credentials." unless email

      email.gsub!('UID=', '')
      Bvadmin::RmsUser.where(email: email).first
    end

    raise Rms::Error::UserAuthenticationError, "User ``#{email}'' does not have the necessary privileges." unless @user
    @user
  end
end
