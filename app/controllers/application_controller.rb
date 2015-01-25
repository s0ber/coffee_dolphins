class ApplicationController < ActionController::Base
  layout 'admin'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  self.responder = Responders::AppResponder
  respond_to :html, :json, :al

  rescue_from ActiveRecord::RecordInvalid, with: :process_failed_validation

protected

  def render_success(options = {})
    render json: {success: true}.merge(options)
  end

  def render_partial(template, options = {})
    render json: {
      success: true,
      notice: options[:notice],
      html: render_to_string(partial: template, layout: false, formats: [:html], locals: options)
    }
  end

  def render_modal(title = nil)
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
end
