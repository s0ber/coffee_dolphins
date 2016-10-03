class Positions::List < AStream::CollectionAction
  safe_attributes { |performer| Positions::Show.permitted_safe_attributes(performer) }
  permit_resource { |performer, resource| Positions::Show.permit_resource?(performer, resource) }

  def perform_read(performer, query)
    if query[:included]
      included_resources = query[:included].slice('search_keywords')
      Position.order_by_search_count.includes(*included_resources).page(query[:page])
    else
      Position.order_by_search_count.page(query[:page])
    end
  end
end
