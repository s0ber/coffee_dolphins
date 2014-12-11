class Admin::BaseController < ApplicationController
  include IframeStreaming

  before_filter :require_login
  before_filter :pass_variables_to_front

  rescue_from ActiveRecord::RecordInvalid, with: :process_failed_validation

protected

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
