class Landings::Show < AStream::BaseAction
  safe_attributes :title, :_status, :slug
  included_resources :position, :category
  permit_resource { |performer| performer }

  def perform_read(performer, query)
    if query[:included]
      Landing.includes(*query[:included]).all
    else
      Landing.all
    end
  end
end

