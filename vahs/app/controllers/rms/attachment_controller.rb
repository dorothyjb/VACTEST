class Rms::AttachmentController < Rms::ApplicationController
  before_filter :verify_access

  def edit
    @attachment = Bvadmin::RmsAttachment.find(params[:id])

    respond_to do |format|
      format.html { render partial: '/rms/employee/attachment/edit' }
      format.js { render 'rms/attachment/edit' }
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = { "#{params[:id]}": "Attachment does not exist." }
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render 'rms/employee/errors' }
    end
  end

  def undo
    @attachment = Bvadmin::RmsAttachment.find(params[:id])

    respond_to do |format|
      format.html { render partial: '/rms/employee/attachment/show', locals: { attachment: @attachment } }
      format.js { render 'rms/attachment/show' }
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = { "#{params[:id]}": "Attachment does not exist." }
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render 'rms/employee/errors' }
    end
  end

  def delete
    attachment = Bvadmin::RmsAttachment.find(params[:id])
    attachment.destroy

    respond_to do |format|
      flash[:notice] = 'Attachment removed successfully'
      format.js { render 'rms/attachment/delete' }
    end

  rescue Exception
    flash[:error] = { "#{params[:id]}": "File does not exist" }
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render 'rms/attachment/delete_error' }
    end
  end

  def download
    attachment = Bvadmin::RmsAttachment.find(params[:id])
    send_data attachment.filedata, filename: attachment.filename,
                                   type: attachment.filetype,
                                   disposition: 'inline'

  rescue Exception
    flash[:error] = { "#{params[:id]}": "File does not exist" }
    redirect_to :back
  end

  private
  def verify_access
    raise Rms::Error::UserAuthenticationError, "#{current_user.name} does not have access to this resource." unless current_user.has_role? :employee, :admin
  end
end
