class Rms::AwardController < Rms::ApplicationController
  before_filter :verify_access

  def edit
    @award = Bvadmin::EmployeeAwardInfo.find(params[:id])
    respond_to do |format|
      format.html { render partial: '/rms/employee/award/edit' }
      format.js { render 'rms/award/edit' }
    end

  rescue => e
    flash[:error] = { "#{params[:id]}": "Award does not exist." }
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render 'rms/employee/errors' }
    end
  end

  def delete
    award = Bvadmin::EmployeeAwardInfo.find(params[:id])
    award.destroy

    respond_to do |format|
      flash[:notice] = 'Award removed successfully'
      format.js { render 'rms/award/delete' }
    end

  rescue Exception
    flash[:error] = { "#{params[:id]}": "Award does not exist" }
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render 'rms/award/delete_error' }
    end
  end


  private
  def verify_access
    raise Rms::Error::AuthenticationError, "#{current_user.name} does not have access to this resource." unless current_user.has_role? :report, :admin
  end
end
