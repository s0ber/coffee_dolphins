class Admin::Apj::EndpointsController < Admin::Apj::BaseController
  before_action :load_endpoint, only: [:show, :edit, :update, :confirm_destroy, :destroy]

  def show
    @endpoint = @endpoint.decorate
    respond_with(@endpoint)
  end

  def new
    @api_group = ApiGroup.find(params[:api_group_id])
    @endpoint = @api_group.endpoints.build
    render_modal("Create Endpoint For <b>#{@api_group.title}</b>")
  end

  def create
    endpoint = Endpoint.new(endpoint_params)
    endpoint.api_group_id = params[:endpoint][:api_group_id]
    endpoint.save!
    render_success(notice: 'New endpoint is added')
  end

  def edit
    render_modal("Edit Endpoint For <b>#{@endpoint.api_group.title}</b>")
  end

  def update
    @endpoint.update_attributes!(endpoint_params)
    render_success
  end

  def confirm_destroy
    render_modal('Remove Endpoint?')
  end

  def destroy
    @endpoint.destroy
    render_success
  end

  protected

  def load_endpoint
    @endpoint = Endpoint.find(params[:id])
  end

  def endpoint_params
    params
      .fetch(:endpoint, {})
      .permit(:request_method, :path)
  end
end
