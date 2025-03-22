class Admin::Apj::ApiGroupsController < Admin::Apj::BaseController
  before_filter :load_api_group, only: [:show, :edit, :update, :destroy]

  def index
    @api_groups = ApiGroup.all.decorate
    @api_group = ApiGroup.new
    respond_with(@api_groups)
  end

  def create
    @api_group = ApiGroup.create!(api_group_params).decorate
    render_partial('api_group', api_group: @api_group)
  end

  def show
    render_partial('api_group', api_group: @api_group.decorate)
  end

  def edit
    respond_with(@api_group)
  end

  def update
    @api_group.update_attributes!(api_group_params)
    render_success
  end

  def destroy
    @api_group.destroy
    render_success
  end

private
  def load_api_group
    @api_group = ApiGroup.find(params[:id])
  end

  def api_group_params
    params.require(:api_group).permit(:title, :description)
  end
end
