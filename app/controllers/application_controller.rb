class ApplicationController < ActionController::Base


  def authenticate_user

    @current_user = User.find_by(id: session[:user_id])
    redirect_to login_path unless @current_user

  end

end
