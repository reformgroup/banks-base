class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      case current_role
      when "superadmin", "admin" then redirect_to users_path
      when "user" then redirect_to my_profile(user)
      end
      # redirect_back_or user
    else
      flash.now[:danger] = { title: t(".flash.danger.title"), message: t(".flash.danger.message") }
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
