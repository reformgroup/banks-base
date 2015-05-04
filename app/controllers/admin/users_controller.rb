class Admin::UsersController < ApplicationController
  
  before_action :logged_in_user
  before_action :correct_role
  
  layout "dashboard"
  
  def index
    if params[:search]
      @users = User.search(params[:search]).paginate(page: params[:page])
    else
      @users = User.paginate(page: params[:page])
    end
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
      flash[:success] = t ".flash.success.message"
      redirect_to @user
    else
      render "signup"
    end
  end
  
  def update
    @user = User.find params[:id]
    if @user.update_attributes main_user_params
      flash[:success] = t ".flash.success.message"
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

  private
  
  # All params
  def user_params
    params.require(:user).permit( :last_name, 
                                  :first_name, 
                                  :middle_name, 
                                  :email, 
                                  :gender, 
                                  :birth_date, 
                                  :password, 
                                  :password_confirmation, 
                                  :role, 
                                  :avatar)
  end
  
  # Params without password
  def main_user_params
    params.require(:user).permit( :last_name, 
                                  :first_name, 
                                  :middle_name, 
                                  :email, 
                                  :gender, 
                                  :birth_date,
                                  :role, 
                                  :avatar)
  end

  # Before filters

  # Confirms the correct role.
  def correct_role
    redirect_to root_path unless current_role? "admin"
  end
end