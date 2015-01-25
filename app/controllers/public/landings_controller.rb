class Public::LandingsController < Public::BaseController
  before_filter :load_landing, :restrict_access_to_unpublished

  def show
  end

  def images
    @images = @landing.landing_images.for_gallery
    render_modal(@landing.position.title)
  end

  def success
    render(action: :show)
  end

  def success_modal
    render_modal
  end

private

  def load_landing
    @landing = Landing.find_by_slug(params[:landing]).decorate
  end

  def restrict_access_to_unpublished
    require_login if @landing.draft?
  end
end
