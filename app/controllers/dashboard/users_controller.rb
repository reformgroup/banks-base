class Dashboard::UsersController < ApplicationController
  
  before_action :logged_in_user
  before_action :correct_role
  
  layout "sidebar"
  
  def index
    @filter_options = [["#{User.human_attribute_name "last_name"} (#{t('filter.string_asc')})", "last_name_asc"], 
                      ["#{User.human_attribute_name "last_name"} (#{t('filter.string_desc')})", "last_name_desc"], 
                      ["#{t('timestamp.created_at')} (#{t('filter.date_desc')})", "created_at_desc"], 
                      ["#{t('timestamp.created_at')} (#{t('filter.date_asc')})", "created_at_asc"]]
                      
    @selected_filter_options = params[:filter] if params[:filter]
    
    @users = if params[:search] && params[:filter]
      User.search(params[:search], :last_name, :first_name, :middle_name, :email).filter(params[:filter], :last_name, :created_at).paginate(page: params[:page])
    elsif params[:search]
      User.search(params[:search], :last_name, :first_name, :middle_name, :email).paginate(page: params[:page])
    elsif params[:filter]
      User.filter(params[:filter], :last_name, :created_at).paginate(page: params[:page])
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
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t ".flash.success.message"
      redirect_to [:dashboard, @user]
    else
      render "new"
    end
  end
  
  def update
    @user = User.find params[:id]
    if @user.update_attributes main_user_params
      flash[:success] = t ".flash.success.message"
      redirect_to [:dashboard, @user]
    else
      render "edit"
    end
  end
  
  def destroy
    @user = User.find params[:id]
    if @user.destroy
      flash[:success] = t ".flash.success.message"
      redirect_to dashboard_users_path
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
    not_found unless current_role? "admin"
  end

  # Confirms the correct user.
  def correct_user
    user = User.find params[:id]
    not_found unless current_user? user
  end
end
