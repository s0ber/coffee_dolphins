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
      flash.notice = 'Вы успешно вошли на сайт.'
      render json: {
        success: true,
        user: ActiveModel::SerializableResource.new(user, serializer: CurrentUserSerializer),
        browser_redirect: session[:return_to_url] || root_url,
        meta: {notice: 'Вы успешно вошли на сайт.'}
      }
    else
      render_validation_errors(email: ['данные для входа не верны'])
    end
  end

  def destroy
    logout
    notice = 'Сессия завершена.'

    respond_to do |format|
      format.html do
        redirect_to login_url, notice: notice
      end
      format.json do
        render json: {success: true, notice: notice}
      end
    end
  end

  def logged_in_user
    if current_user
      render json: current_user, serializer: CurrentUserSerializer
    else
      render json: {user: nil}
    end
  end

protected

  def redirect_logged_user
    redirect_to(bookmakers_path) if logged_in?
  end

private

  def user_params
    params.fetch(:user).permit(:email, :password, :remember_me)
  end
end
