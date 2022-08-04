class SessionsController < ApplicationController
  before_action :check_session, except: [:destroy]
  before_action :authenticate_user, only: [:destroy]

  def index
    @user = User.new
  end

  def create
    user= User.auth(sessions_params)
    if user
      session[:user_id] = user.id
      redirect_to sites_path
    else
      redirect_to login_path, alert: 'اسم المستخدم او كلمة المرور غير صحيحة.'
    end
  end


  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "تم تسجيل الخروج بنجاح"
  end

  private

  def sessions_params
    params.require(:user).permit(:username, :password)
  end

  def check_session
    return unless session[:user_id]
    user=User.find_by(id: session[:id])
    redirect_to sites_path if user
  end

end
