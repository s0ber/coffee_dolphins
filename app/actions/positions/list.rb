class Positions::List < AStream::BaseAction
  INCLUDED_RESOURCES = [:search_keywords]

  safe_attributes { |performer| Positions::Show.permitted_safe_attributes(performer) }
  permit_resource { |performer, resource| Positions::Show.permit_resource?(performer, resource) }

  def perform_read(performer, query)
    if query[:included]
      Position.order_by_search_count.includes(query[:included] & INCLUDED_RESOURCES).page(query[:page])
    else
      Position.order_by_search_count.page(query[:page])
    end
  end
end
