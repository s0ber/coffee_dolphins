class Admin::Apj::Resources::ExamplesController < Admin::Apj::BaseController
  before_filter :load_example, only: [:show, :edit, :update, :destroy]

  def create
    example = Example.new(example_params)
    example.resource = Resource.find(params[:resource_id])
    example.save!

    render_partial('admin/apj/resources/example', example: example.decorate)
  end

  def show
    render_partial('admin/apj/resources/example', example: @example.decorate)
  end

  def edit
    respond_with(@example)
  end

  def update
    @example.update_attributes!(example_params)
    render_success(notice: 'Example successfully updated')
  end

  def destroy
    @example.destroy
    render_success
  end

private
  def load_example
    @example = Example.find(params[:id])
  end

  def example_params
    params.require(:example).permit(
      :e_id,
      example_fields_attributes: [:id, :field_id, :value]
    )
  end
end
