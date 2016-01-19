class Positions::Show < AStream::BaseAction
  safe_attributes :title, :image_url, :apishops_position_id, :category, :price, :profit, :availability_level
  permit_resource { |performer| performer }

  def perform_read(performer, query)
    if query[:id] && query[:included]
      included_resources = query[:included].slice(:search_keywords)
      Position.includes(*included_resources).find(query[:id])
    end
  end
end
