class Admin::Apj::BaseController < Admin::BaseController
  before_action :set_api_layout_flag

private

  def set_api_layout_flag
    @api_layout = true
  end
end
