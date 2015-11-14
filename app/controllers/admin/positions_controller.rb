class Admin::PositionsController < Admin::BaseController
  before_filter :load_position, only: [:cut, :edit, :update, :destroy, :like, :unlike]

  def index
    @position = Position.new
    respond_with(@positions)
  end

  def cut
    @position = @position.decorate
    render_partial('position', position: @position)
  end

  def show
    @position = Position.with_all_details.find(params[:id]).decorate
    respond_with(@position)
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

  def favorite
    @positions = Position.favorite.order_by_search_count.includes(:search_keywords, :landing).page(params[:page])
    respond_with(@positions)
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

  def like
    @position.liked = true
    @position.save!
    render_success(notice: 'Позиция добавлена в избранное')
  end

  def unlike
    @position.liked = false
    @position.save!
    render_success(notice: 'Позиция удалена из избранного')
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
              search_keywords_attributes: [:id, :name, :search_count, :_destroy])
  end
end
