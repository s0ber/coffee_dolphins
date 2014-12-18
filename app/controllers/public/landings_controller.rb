class Public::LandingsController < Public::BaseController
  layout 'public_landing'

  before_filter :load_landing, :restrict_access_to_unpublished

  def show
  end

private

  def load_landing
    @landing = Landing.find_by_slug(params[:landing]).decorate
  end

  def restrict_access_to_unpublished
    require_login if @landing.draft?
  end
end
