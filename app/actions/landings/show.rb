class Landings::Show < AStream::BaseAction
  INCLUDED_RESOURCES = [:position, :category]

  safe_attributes(%i[title slug _status] + INCLUDED_RESOURCES)
  permit_resource { |performer| performer }

  def perform_read(performer, query)
    if query[:included]
      Landing.includes(query[:included] & INCLUDED_RESOURCES).all
    else
      Landing.all
    end
  end
end
