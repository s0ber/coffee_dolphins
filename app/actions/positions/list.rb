class Positions::List < AStream::BaseAction
  safe_attributes { |performer| Positions::Show.permitted_safe_attributes(performer) }
  permit_resource { |performer, resource| Positions::Show.permit_resource?(performer, resource) }
  included_resources :search_keywords

  def perform_read(performer, query)
    if query[:included]
      Position.order_by_search_count.includes(*query[:included]).page(query[:page])
    else
      Position.order_by_search_count.page(query[:page])
    end
  end
end
