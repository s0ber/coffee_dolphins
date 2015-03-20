class Public::BaseController < ApplicationController
  layout 'public'

  before_filter :pass_variables_to_front

  def pass_variables_to_front
    gon.push(
      env: Rails.env
    )

    Landing::COLOR_SCHEMES.each do |color, id|
      gon.push("#{color}_color_scheme" => Rails.application.assets.find_asset("public/old_template/color_schemes/#{color}.css").digest_path)
    end
  end
end
