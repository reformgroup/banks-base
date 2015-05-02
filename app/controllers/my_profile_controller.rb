class MyProfileController < ApplicationController
  
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :correct_user,   only: [:show, :edit, :update]
  
  layout "dashboard"
  
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find params[:id]
    if @user.update_attributes main_user_params
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
  
  def main_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :gender, :birth_date, :avatar)
  end
  
  # Before filters

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_url unless current_user? @user
  end
end
