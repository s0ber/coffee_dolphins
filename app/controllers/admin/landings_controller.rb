class Admin::LandingsController < Admin::BaseController
  before_filter :load_landing, only: [:show, :edit, :update, :destroy, :reorder_images]

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
    render_success(notice: 'Картинка успешно загружена', image: {id: landing_image.id, path: landing_image.image.thumb.url})
  end

  def reorder_images
    landing_images = @landing.landing_images
    landing_images_ids = params[:indexes]

    landing_images_ids.each_with_index do |landing_image_id, index|
      landing_images.where(id: landing_image_id).update_all(position: index)
    end

    render_success(notice: 'Порядок картинок изменен')
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
              :color,
              :video_id,
              :short_description,
              :why_question,
              :description_title,
              :description_text,
              :advantages_title,
              :advantages_text,
              :reviews_title,
              :category_id,
              :footer_title,
              :html_title,
              :meta_description,
              reviews_attributes: [:id, :author, :author_gender, :text, :landing_id, :author_profession],
              landing_images_attributes: [:id, :alt_text, :for_gallery, :_destroy])
  end
end
