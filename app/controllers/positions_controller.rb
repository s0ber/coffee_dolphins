class PositionsController < ApplicationController
  before_filter :load_position, only: [:show, :edit, :update, :destroy]

  def index
    @positions = Position.page(params[:page]).preload(:search_keywords)
    @position = Position.new
    respond_with(@positions)
  end

  def show
    @position = @position.decorate
    render_partial('position', position: @position)
  end

  def create
    @position = Position.create!(position_params).decorate
    render_partial('position', position: @position)
  end

  def edit
    @position = @position.decorate
    respond_with(@position)
  end

  def update
    @position.update_attributes!(position_params)
    render_success
  end

  def destroy
    @position.destroy
    render_success
  end

  def prepare_import
    @position = Position.first
    render_modal 'Импортировать позиции Apishops'
  end

  def import
    file = params[:positions] && params[:positions][:file]
    if file.blank?
      render_validation_errors(file: ['не может быть пустым'])
    else
      Position.import(file)
      render_success(redirect: positions_path, notice: 'Позиции успешно импортированы.')
    end
  end

private

  def load_position
    @position = Position.find(params[:id])
  end


  def position_params
    params
      .fetch(:position, {})
      .permit(:apishops_position_id, :title, :category, :price, :profit,
              :availability_level, :image_url, :file,
              search_keywords_attributes: [:id, :name, :_destroy])
  end
end
