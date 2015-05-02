class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :correct_user,   only: [:show, :edit, :update]
  
  layout "dashboard", except: :signup
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find params[:id]
  end
  
  def edit
    @user = User.find params[:id]
  end
  
  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".flash.success.message"
      redirect_to @user
    else
      render "signup"
    end
  end
  
  def update
    @user = User.find params[:id]
    if @user.update_attributes main_user_params
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "edit"
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path
  end 
  
  def signup
    @user = User.new
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :gender, :birth_date, :avatar)
  end
  
  def main_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :gender, :birth_date, :avatar)
  end

  # Before filters

  # Confirms the correct user.
  def correct_user
    unless current_role_include? "superadmin", "admin"
      @user = User.find(params[:id])
      redirect_to root_url unless current_user? @user
    end
  end
end
