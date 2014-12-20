class Admin::LandingsController < Admin::BaseController
  before_filter :load_landing, only: [:show, :edit, :update, :destroy]

  def index
    @landings = Landing.includes(:category, :position).all.decorate
    respond_with(@landings)
  end

  def new
    @position = Position.find(params[:position_id])
    @landing = @position.build_landing
    render_modal('Форма создания нового лендинга')
  end

  def create
    @landing = Landing.new(landing_params)
    @landing.position = Position.find(params[:landing][:position_id])
    @landing.save!

    render_success(redirect: edit_landing_path(@landing), notice: 'Лендинг успешно создан')
  end

  def edit
    @landing = @landing.decorate
    respond_with(@landing)
  end

  def update
    @landing.update_attributes!(landing_params)
    render_success(redirect: edit_landing_path(@landing), notice: 'Лендинг обновлен')
  end

  def destroy
    @landing.destroy
    render_success(notice: 'Лендинг успешно удален')
  end

  def upload_image
    landing_image = LandingImage.new(image: params[:qqfile])
    landing_image.landing = Landing.find(params[:landing_id])

    landing_image.save!
    render_success(image_path: landing_image.image.url)
  end

private

  def load_landing
    @landing = Landing.find(params[:id])
  end

  def landing_params
    params
      .fetch(:landing, {})
      .permit(:title,
              :slug,
              :video_id,
              :short_description,
              :why_question,
              :description_title,
              :description_text,
              :advantages_title,
              :advantages_text,
              :reviews_title,
              :category_id,
              reviews_attributes: [:id, :author, :author_gender, :text, :landing_id, :author_profession])
  end
end
