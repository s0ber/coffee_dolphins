class Positions::Show < AStream::BaseAction
  INCLUDED_RESOURCES = [:search_keywords]
  safe_attributes %i[title image_url apishops_position_id category price profit availability_level] + INCLUDED_RESOURCES
  permit_resource { |performer| performer }

  def perform_read(performer, query)
    if query[:id]
      Position.includes(query[:included] & INCLUDED_RESOURCES).find(query[:id])
    end
  end
end
