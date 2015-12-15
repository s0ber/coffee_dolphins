class Admin::BookmakersController < Admin::BaseController
  before_filter :load_bookmaker, only: [:show, :edit, :update, :destroy]

  def index
    @bookmakers = BookmakerDecorator.decorate_collection(Bookmaker.by_ammount_rub)
    @bookmaker = Bookmaker.new
    respond_with(@bookmakers)
  end

  def create
    @bookmaker = Bookmaker.create!(bookmaker_params).decorate
    render_partial('bookmaker', bookmaker: @bookmaker)
  end

  def show
    render_partial('bookmaker', bookmaker: @bookmaker.decorate)
  end

  def edit
    respond_with(@bookmaker)
  end

  def update
    @bookmaker.update_attributes!(bookmaker_params)
    render_success
  end

  def destroy
    @bookmaker.destroy
    render_success
  end

private
  def load_bookmaker
    @bookmaker = Bookmaker.find(params[:id])
  end

  def bookmaker_params
    params.require(:bookmaker).permit(:title, :description, :image, :currency, :statistics_url)
  end
end

