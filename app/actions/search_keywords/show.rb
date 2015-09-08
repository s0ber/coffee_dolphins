class SearchKeywordsActions::Show < Actions::Base
  permit do |performer, search_keyword|
    true if performer
  end

  def perform(query)
  end
end


