class Admin::Apj::TypesController < Admin::Apj::BaseController
  before_filter :load_type, only: [:show, :edit, :update, :destroy]

  def index
    @types = Type.all.decorate
    @type = Type.new
    respond_with(@types)
  end

  def create
    @type = Type.create!(type_params).decorate
    render_partial('type', type: @type)
  end

  def show
    render_partial('type', type: @type.decorate)
  end

  def edit
    respond_with(@type)
  end

  def update
    @type.update_attributes!(type_params)
    render_success
  end

  def destroy
    @type.destroy
    render_success
  end

private
  def load_type
    @type = Type.find(params[:id])
  end

  def type_params
    params.require(:type).permit(:name, :description)
  end
end
