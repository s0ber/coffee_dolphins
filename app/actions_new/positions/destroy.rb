class Actions::Positions::Destroy < Actions::Base
  query_by :positions, :position_ids
  query_by_action('positions#show') { |response_body| {positions: response_body} }

  def perform_read(query)
    positions =
      if query[:positions]
        query[:positions]
      else
        Position.find(query[:position_ids])
      end

    response = positions.map do |position|
      if position.has_landing?
        {id: position.id,
         position: position,
         status: :unprocessable_entity,
         message: "Can't remove position <b>#{position.title}</b>, because it has associated landing."}
      elsif position._status == :removed
        {id: position.id,
         position: position,
         status: :unprocessable_entity,
         message: "Can't remove position <b>#{position.title}</b>, because it is already removed."}
      else
        {id: position.id,
         position: position,
         message: "Are you sure you want to remove position <b>#{position.title}</b>?"}
      end
    end

    ActionResponse.new(action: self, body: response)
  end

  permit do |performer, item|
    Actions::Positions::Show.check_permissions(performer, item) && true
  end

  def perform_write(query)
    response = perform_read(query).body.map do |item|
      if !response.accessible_item?(item)
        item
      elsif
        item.destroy!
        item.merge(message: "Position successfully removed.")
      else
        item.merge(status: :server_error, message: "Something went wrong.")
      end
    end

    ActionResponse.new(action: self, body: response)
  end

  serialize do |item|
    item.slice(:id, :status, :message)
  end
end
