class SessionsController < ApplicationController
  skip_before_filter :require_login

  def new
    if current_user
      redirect_to root_url
    end
  end

  def create
    user = login(params[:email], params[:password], params[:remember_me])

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
end
