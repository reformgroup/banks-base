class Admin::MyProfileController < ApplicationController
  
  before_action :logged_in_user
  before_action :correct_role
  before_action :correct_user
  
  layout "dashboard"
  
  def show
    @user = User.find params[:id]
  end

  def edit
    @user = User.find params[:id]
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
    @user = User.find params[:id]
    @user.destroy
    redirect_to root_path
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

  # Confirms the correct user.
  def correct_user
    user = User.find params[:id]
    redirect_to root_path unless current_user? user
  end
end
