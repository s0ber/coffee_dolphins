class Admin::Apj::ResourcesController < Admin::Apj::BaseController
  before_filter :load_resource, only: [:show, :edit, :update, :destroy]

  def index
    @resources = Resource.all.decorate
    @resource = Resource.new
    respond_with(@resources)
  end

  def create
    @resource = Resource.create!(resource_params).decorate
    render_partial('resource', resource: @resource)
  end

  def show
    render_partial('resource', resource: @resource.decorate)
  end

  def edit
    respond_with(@resource)
  end

  def update
    @resource.update_attributes!(resource_params)
    render_success
  end

  def destroy
    @resource.destroy
    render_success
  end

private

  def load_resource
    @resource = Resource.find(params[:id])
  end

  def resource_params
    params.require(:resource).permit(:name, fields_attributes: [:id, :type_id, :position, :name, :_destroy])
  end
end
