Actions::Positions::Show = Class.new do
  def allowed_query_attributes(performer, query)
    if performer.admin?
      query.permit(:page, include: [:search_keywords, :landings], child_actions: [])
    else
      query.permit(:page)
    end
  end

  def perform_read(performer, query)
    positions =
      if query[:include]
        Position.order_by_search_count.includes(query[:include]).page(query[:page])
      else
        Position.order_by_search_count.all.page(query[:page])
      end

    ActionResponse.new(action: 'positions#show', body: positions, include: query[:include])
  end

  def permit(performer, item)
    true
  end

  def serialize(performer, position, included_models)
    PositionSerializer.new(position, include: included_models)
  end
end
