class ApplicationController < ActionController::Base

  include IframeStreaming

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  self.responder = Responders::AppResponder
  respond_to :html, :json, :al

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

end
