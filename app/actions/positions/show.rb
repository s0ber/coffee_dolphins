class Positions::Show < AStream::BaseAction
  query_params :id
  safe_attributes :title, :image_url, :apishops_position_id, :category, :price, :profit, :availability_level
  permit_resource { |performer| performer }
  included_resources :search_keywords

  def perform_read(performer, query)
    if query[:id]
      Position.includes(*query[:included]).find(query[:id])
    end
  end
end
