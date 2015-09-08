class PositionsActions::Index < Actions::Base
  def self.permit(performer, positions)
    PositionsActions::Show.permit_collection(performer, positions)
  end

  def perform(query)
  end
end
