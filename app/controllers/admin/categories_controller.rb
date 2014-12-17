class Admin::CategoriesController < Admin::BaseController
  before_filter :load_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all.decorate
    @category = Category.new
    respond_with(@categories)
  end

  def create
    @category = Category.create!(category_params).decorate
    render_partial('category', category: @category)
  end

  def show
    render_partial('category', category: @category.decorate)
  end

  def edit
    respond_with(@category)
  end

  def update
    @category.update_attributes!(category_params)
    render_success
  end

  def destroy
    @category.destroy
    render_success
  end

private
  def load_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:title, :slug, :description, :html_title, :meta_description)
  end
end
