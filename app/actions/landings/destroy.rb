class Landings::Destroy < AStream::BaseAction
  query_params :id
  safe_attributes :id
  permit_resource { |performer| performer }

  def perform_update(performer, query)
    @landing = Landing.find(query[:id])
    @landing.destroy
    AStream::Response.new(message: 'Лендинг успешно удален', body: @landing)
  end
end

