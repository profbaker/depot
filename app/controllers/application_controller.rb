class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authorize
  before_action :check_for_login
  before_action :set_i18n_locale_from_params



  protected

  def check_for_login
    temp = User.find_by(id: session[:user_id])
    if temp
      @logged_in_user_name = temp.name
    end
  end

  def authorize
    unless User.find_by(id: session[:user_id]) || User.count == 0
      redirect_to login_url, notice: "Please Log In"
    end
  end

  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.map(&:to_s).include?(params[:locale])
        I18n.locale = params[:locale]
      else
        flash.now[:notice] = "#{params[:locale]} translation not available."
        logger.error flash.now[:notice]
      end
    end
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
