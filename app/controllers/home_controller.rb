class HomeController <ApplicationController
  def index
    # Set the monthly work object of the current month
    @monthly_work = helpers.get_current_monthly_work

    # Set the thank variable if it present in params
    @thank = params[:thank] || false
  end

  def switch_locale
    # Switch the language to the in params given language
    loc = params[:locale]
    I18n.locale = loc
    session[:locale] = loc
    redirect_to root_path
  end

  def switch_mode
    # Switch the mode to the in mode given language
    mode = params[:mode]
    session[:mode] = mode
    redirect_to root_path
  end
end