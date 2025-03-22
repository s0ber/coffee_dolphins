class Landings::Show < AStream::CollectionAction
  safe_attributes :title, :_status, :slug
  permit_resource { |performer| performer }

  def perform_read(performer, query)
    if query[:included]
      included_resources = query[:included].slice('position', 'category')
      Landing.includes(*included_resources).all
    else
      Landing.all
    end
  end
end

