class SearchKeywords::Show < AStream::BaseAction
  safe_attributes :name, :search_count
  permit_resource { |performer| performer }

  def perform_read(performer, query)
    []
  end
end

