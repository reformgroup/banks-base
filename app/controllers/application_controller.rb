class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  include SessionsHelper
  
  protect_from_forgery with: :exception
  before_action :set_locale
  
  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
  
  private
  
  # Before filters
  
  def set_locale
    I18n.locale = params[:locale] || current_user.try(:locale) || I18n.default_locale
  end
  
  protected

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t ".logged_in_user.flash.danger.message"
      redirect_to login_url
    end
  end
end
