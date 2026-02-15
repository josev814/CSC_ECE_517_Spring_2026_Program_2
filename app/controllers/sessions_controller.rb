class SessionsController < ApplicationController
  def new
  end

  def create
    params_sess = params['session']
    @admin = Admin.authenticate_by(username: params_sess['username'], password: params_sess['password'])
    if @admin
      session[:admin_id] = @admin.id
      redirect_to admins_path
      return
    end
    @volunteer = Volunteer.authenticate_by(username:params_sess['username'], password: params_sess['password'])
    if @volunteer
      session[:user_id] = @volunteer.id
      redirect_to root_path
      return
    end
    flash.now[:alert] = "Invalid Credentials"
    render :new
  end

  def destroy
    session[:admin_id] = nil if session.has_key?(:admin_id)
    session[:user_id] = nil if session.has_key?(:user_id)
    redirect_to root_path, notice: "You have been logged out"
  end
end
