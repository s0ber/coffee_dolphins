class ApplicationController < ActionController::Base
  include IframeStreaming

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  self.responder = Responders::AppResponder
  respond_to :html, :json, :al

  before_filter :require_login
  before_filter :pass_variables_to_front

  rescue_from ActiveRecord::RecordInvalid, with: :process_failed_validation

  def root
    redirect_to positions_path
  end

protected

  def render_success(options = {})
    render json: {success: true}.merge(options)
  end

  def render_partial(template, options = {})
    render json: {
      success: true,
      html: render_to_string(partial: template, layout: false, formats: [:html], locals: options)
    }
  end

  def render_modal(title)
    render json: {
      title: title,
      html: render_to_string(action: action_name, layout: false, formats: [:html])
    }
  end

  def process_failed_validation(exception)
    render_validation_errors(exception.record.errors)
  end

  def render_validation_errors(errors)
    render json: {errors: errors}, status: :unprocessable_entity
  end

  def assets_md5_hash
    assets_hash = Rails.application.assets.find_asset('application.js').digest_path

    # this calculation is heavy enough for development
    if Rails.env.production?
      assets_hash += Rails.application.assets.find_asset('application.css').digest_path
    end

    assets_hash
  end

private

  def pass_variables_to_front
    gon.push(
      assets_md5_hash: assets_md5_hash
    )
  end



  def not_authenticated
    redirect_to login_url, alert: 'Вы должны войти, чтобы получить доступ к запрашиваемой странице.'
  end

  helper_method :assets_md5_hash
end
