module Actions::Positions::Show
  extend self

  QUERY_ATTRIBUTES = [:page]
  INCLUDED_RESOURCES = [:search_keywords, :landings]
  CHILD_ACTIONS = [Positions::Approve, Positions::Reject]

  def perform_read(performer, query)
    if query[:include]
      Position.order_by_search_count.includes(*query[:include]).page(query[:page])
    else
      Position.order_by_search_count.all.page(query[:page])
    end
  end

  def permit(performer, position)
    case performer
    when Company
      position.company_id == performer.id
    when Admin
      true
    end
  end

  def serialize(performer, position)
    PositionSerializer.new(position: included_models)
  end
end
