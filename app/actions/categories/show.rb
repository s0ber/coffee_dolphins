class Categories::Show < AStream::BaseAction
  safe_attributes :title, :description
  permit_resource { |performer| performer }

  def perform_read(performer, query)
    Category.all
  end
end
