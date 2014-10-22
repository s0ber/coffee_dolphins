class ApplicationController < ActionController::Base
  before_filter :require_login

  include IframeStreaming

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  self.responder = Responders::AppResponder
  respond_to :html, :json, :al

  rescue_from ActiveRecord::RecordInvalid, with: :render_validation_errors

  def root
    redirect_to positions_path
  end

protected

  def render_partial(template, options = {})
    respond_with(nil) do |format|
      format.json do
        render json: {
          success: true,
          html: render_to_string(partial: template, layout: false, formats: [:html], locals: options)
        }
      end
    end
  end

  def render_validation_errors(exception)
    render json: {errors: exception.record.errors}, status: :unprocessable_entity
  end

private

  def not_authenticated
    redirect_to login_url, alert: 'Вы должны войти, чтобы получить доступ к запрашиваемой странице.'
  end

end
