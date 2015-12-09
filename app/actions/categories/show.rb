class Categories::Show < AStream::CollectionAction
  safe_attributes :title, :description
  permit_resource { |performer| performer }

  def perform_read(performer, query)
    Category.all
  end
end
