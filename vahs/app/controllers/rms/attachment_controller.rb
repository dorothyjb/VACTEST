class Rms::AttachmentController < Rms::ApplicationController
  before_filter :verify_access

  def download
    attachment = Bvadmin::RmsAttachment.find(params[:id])
    send_data attachment.filedata, filename: attachment.filename,
                                   type: attachment.filetype,
                                   disposition: 'attachment'

  rescue Exception
    flash[:error] = { "#{params[:id]}": "File does not exist" }
    redirect_to :back
  end

  private
  def verify_access
    raise Rms::Error::AuthenticationError, "#{current_user.name} does not have access to this resource." unless current_user.has_role? :report, :admin
  end
end
