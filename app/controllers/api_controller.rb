class ApiController < ApplicationController
  protect_from_forgery with: :exception, unless: -> { action_name == 'post' && params[:post] == 'users#login' }

  before_action do |controller|
    if !controller.current_user_requested? && !controller.login_credentials_submitted?
      controller.require_login
    end
  end

  after_action do |controller|
    if controller.login_credentials_submitted?
      controller.set_csrf_token_cookie
    end
  end

  def get
    if params[:get]
      response = AStream::run(current_user, params, self)
      render json: response
    else
      render json: {}, status: :not_found
    end
  end

  def post
    if params[:post]
      response = AStream::run(current_user, params, self)
      render json: response
    else
      render json: {}, status: :not_found
    end
  end

  def not_authenticated
    render json: {success: false}, status: :unauthorized
  end

  protected

  def set_csrf_token_cookie
    cookies[:_csrf_token] = form_authenticity_token if protect_against_forgery?
  end

  def current_user_requested?
    action_name == 'get' && params[:get] == 'current_user#show'
  end

  def login_credentials_submitted?
    action_name == 'post' && params[:post] == 'current_user#login'
  end
end
