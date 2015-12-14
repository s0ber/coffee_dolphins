class Categories::Destroy < AStream::BaseAction
  query_params :id
  safe_attributes :id
  permit_resource { |performer| performer }

  def perform_update(performer, query)
    @category = Category.find(query[:id])
    @category.destroy
    @category
    AStream::Response.new(message: 'Категория успешно удалена', body: @category)
  end
end

