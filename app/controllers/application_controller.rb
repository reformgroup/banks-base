class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception
  include SessionsHelper
  
  before_action :set_locale
  
  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
  
  private
  
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
  protected
  
  # Before filters

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "users_controller.logged_in_user.flash.danger.message"
      redirect_to login_url
    end
  end
end
