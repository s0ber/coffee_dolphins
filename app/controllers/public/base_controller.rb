class Public::BaseController < ApplicationController
  before_filter :pass_variables_to_front

  def pass_variables_to_front
    gon.push(
      env: Rails.env
    )

    if Rails.env.production?
      Landing::COLOR_SCHEMES.each do |color, id|
        gon.push("#{color}_color_scheme" => Rails.application.assets.find_asset("public/color_schemes/#{color}.css").digest_path)
      end
    end
  end
end
