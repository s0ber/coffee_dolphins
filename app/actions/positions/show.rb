class Positions::Show < AStream::CollectionAction
  query_params :page
  safe_attributes :title, :image_url, :apishops_position_id, :category, :price, :profit, :availability_level
  permit_resource { |performer| performer }
  included_resources :search_keywords

  def perform_read(performer, query)
    if query[:included]
      Position.order_by_search_count.includes(*query[:included]).page(query[:page])
    else
      Position.order_by_search_count.page(query[:page])
    end
  end
end
