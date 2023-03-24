class ApplicationController < ActionController::Base
  # Before every action authenticate the user, if the user not authenticated redirect to login page from devise
  before_action :authenticate_user!

  before_action def set_locale
    # Set the local language, default ist english
    if session[:locale].present?
      logger.info "Setting locale to #{session[:locale]}"
      I18n.locale = session[:locale]
    else
      I18n.locale = :en
    end
  end

  before_action def set_mode
    # Set the mode, default is computer mode
    if session[:mode].present?
      logger.info "Setting mode to #{session[:mode]}"
      @mobile_mode = (session[:mode] == 'phone')
    else
      logger.info "Setting mode to default mode pc"
      @mobile_mode = false
    end
  end
end
