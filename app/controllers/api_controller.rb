class ApiController < ApplicationController
  class LoginFilter
    def self.before(controller)
      controller.require_login unless login_requested?(controller)
    end

    def self.login_requested?(controller)
      controller.action_name == 'post' && controller.params[:post] == 'users#login'
    end
  end

  before_action LoginFilter

  def get
    if get_params[:get]
      response = AStream::run(current_user, get_params, self)
      render json: {actions: response}
    else
      render json: {}, status: :not_found
    end
  end

  def post
    if post_params[:post]
      response = AStream::run(current_user, post_params, self)
      render json: {actions: response}
    else
      render json: {}, status: :not_found
    end
  end

  def not_authenticated
    respond_to do |format|
      format.html do
        redirect_to(root_path)
      end
      format.json do
        render json: {success: false}, status: :unauthorized
      end
    end
  end

  private

  def get_params
    params.permit(:get, :query, :pipe)
  end

  def post_params
    params.permit(:post, :query, :pipe)
  end
end
