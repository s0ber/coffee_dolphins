class Positions::Destroy < AStream::BaseAction
  safe_attributes :id
  permit_resource { |performer| performer }

  def perform_update(performer, query)
    @position = Position.find(query[:id])
    @position.destroy
    @position
  end
end
