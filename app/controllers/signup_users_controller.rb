class SignupUsersController < ApplicationController
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".flash.success.message"
      redirect_to @user
    else
      render "new"
    end
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
end
