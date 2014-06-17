class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Run the following actions before those in other controllers
  before_action :require_login, :set_curr_user

  # Public - Renders a 404 Not Found page
  def render_404
    render status: 404, text: "Error 404: This resource was not found!"
  end

  private
  def require_login
    unless session[:user_id] != nil
      redirect_to login_users_path, 
                  notice: "You must be logged in to access this section!"
    end
  end

  # Private - If a :user_id exists in the session hash, sets the 
  #           @curr_user variable so it's available in all views
  def set_curr_user
    if session[:user_id] != nil
      @curr_user = User.find( session[:user_id] )
    end
  end
end
