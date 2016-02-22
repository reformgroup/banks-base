class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  include SessionsHelper
  
  protect_from_forgery with: :exception
  before_action :set_locale
  before_filter :set_stamper
  after_filter  :reset_stamper
  
  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
  
  private
  
  # Before filters
  
  def set_locale
    I18n.locale = params[:locale] || current_user.try(:locale) || I18n.default_locale
  end
  
  # The <tt>set_stamper</tt> method as implemented here assumes a couple
  # of things. First, that you are using a +User+ model as the stamper
  # and second that your controller has a <tt>current_user</tt> method
  # that contains the currently logged in stamper. If either of these
  # are not the case in your application you will want to manually add
  # your own implementation of this method to the private section of
  # the controller where you are including the Userstamp module.
  def set_stamper
    User.stamper = self.current_user
  end

  # The <tt>reset_stamper</tt> method as implemented here assumes that a
  # +User+ model is being used as the stamper. If this is not the case then
  # you will need to manually add your own implementation of this method to
  # the private section of the controller where you are including the
  # Userstamp module.
  def reset_stamper
    User.reset_stamper
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
