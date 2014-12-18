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

private

  def load_landing
    @landing = Landing.find(params[:id])
  end

  def landing_params
    params.require(:landing).permit(:title, :slug, :category_id)
  end
end
