class Rms::TrainingController < Rms::ApplicationController
  before_filter :verify_access

  def edit
    @training = Bvadmin::Training.find(params[:id])

    respond_to do |format|
      format.html { render partial: '/rms/employee/training/edit' }
      format.js { render 'rms/training/edit' }
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = { "#{params[:id]}": "Training class does not exist" }
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render 'rms/training/errors' }
    end
  end

  def delete
    training = Bvadmin::Training.find(params[:id])
    training.destroy

    respond_to do |format|
      flash[:notice] = "#{training.class_name} was successfully removed"
      format.js { render 'rms/training/delete' }
    end

  rescue ActiveRecord::RecordNotFound
    flash[:error] = { "#{params[:id]}": "Training ID does not exist" }
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render 'rms/training/delete_error' }
    end
  end

  private
  def verify_access
    raise Rms::Error::UserAuthenticationError, "#{current_user.name} does not have access to this resource." unless current_user.has_role? :employee, :admin
  end
end
