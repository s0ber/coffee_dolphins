class LandingsController < ApplicationController
  before_filter :load_landing, only: [:show, :edit, :update, :destroy]

  def index
    @landings = Landing.all.decorate
    @landing = Landing.new
    respond_with(@landings)
  end

  def create
    @landing = Landing.create!(landing_params).decorate
    render_partial('landing', landing: @landing)
  end

  def show
    render_partial('landing', landing: @landing.decorate)
  end

  def edit
    respond_with(@landing)
  end

  def update
    @landing.update_attributes!(landing_params)
    render_success
  end

  def destroy
    @landing.destroy
    render_success
  end

private

  def load_landing
    @landing = Landing.find(params[:id])
  end

  def landing_params
    params.require(:landing).permit(:title, :slug, )
  end
end
