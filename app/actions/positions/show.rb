class Positions::Show < AStream::BaseAction
  safe_attributes :title
  permit_resource true

  def perform_read(performer, query)
    []
  end

  def perform_update(performer, query)
    Position.all
  end
end
