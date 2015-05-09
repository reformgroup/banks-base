class Admin::UsersController < ApplicationController
  
  before_action :logged_in_user
  before_action :correct_role
  
  layout "dashboard"
  
  def index
    @filter_options = [["Last name (a-z)", "last_name_asc"], ["Last name (z-a)", "last_name_desc"], ["Created at (new-old)", "created_at_desc"], ["Created at (old-new)", "created_at_asc"]]
    @selected_filter_options = params[:filter] if params[:filter]
    @users = if params[:search] || params[:filter]
      User.search(params[:search], :last_name, :first_name, :middle_name).filter(params[:filter], :last_name, :created_at).paginate(page: params[:page])
    else
      User.paginate(page: params[:page])
    end
  end
  
  def show
    @user = User.find params[:id]
  end
  
  def new
    @user = User.new
  end
  
  def edit
    @user = User.find params[:id]
  end
  
  def create
    @user = User.new main_user_params
    @user.generate_password
    if @user.save
      flash[:success] = t ".flash.success.message"
      redirect_to admin_user_path(@user)
    else
      render "new"
    end
  end
  
  def update
    @user = User.find params[:id]
    if @user.update_attributes main_user_params
      flash[:success] = t ".flash.success.message"
      redirect_to admin_user_path(@user)
    else
      render "edit"
    end
  end
  
  def destroy
    @user = User.find params[:id]
    if @user.destroy
      flash[:success] = t ".flash.success.message"
      redirect_to admin_users_path
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