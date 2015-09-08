class SearchKeywordsActions::Show < Actions::Base
  def self.permit(perform, search_keyword)
    true if performer
  end

  def perform(query)
  end
end


