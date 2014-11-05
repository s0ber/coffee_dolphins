class PositionsController < ApplicationController
  before_filter :load_position, only: [:show, :edit, :update, :destroy]

  def index
    @positions = Position.by_creation.decorate
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
    render json: {success: true}
  end

  def destroy
    @position.destroy
    render json: {success: true}
  end

  def import
    @position = Position.first
    render_modal 'Импортировать позиции Apishops'
  end

private

  def load_position
    @position = Position.find(params[:id])
  end


  def position_params
    params.require(:position).permit(:apishops_position_id, :title, :category, :price, :profit, :availability_level, :image_url)
  end
end
