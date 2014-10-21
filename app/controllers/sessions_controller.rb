class SessionsController < ApplicationController
  before_filter :redirect_logged_user, only: [:new]
  skip_before_filter :require_login, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    user = login(user.email, user.password, user.remember_me)

    if user
      redirect_back_or_to root_url, notice: 'Вы успешно вошли на сайт.'
    else
      flash.alert = 'Email или пароль не верны'
      redirect_to :back
    end
  end

  def destroy
    logout
    redirect_to login_url, notice: 'Сессия завершена.'
  end

protected

  def redirect_logged_user
    redirect_to(root_url) if logged_in?
  end

private

  def user_params
    params.require(:user).permit(:email, :password, :remember_me)
  end

end
