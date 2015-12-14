class CurrentUser::Logout < AStream::BaseAction
  permit_resource true

  def perform_update(performer, query)
    controller.logout
    AStream::Response.new(message: 'Сессия завершена.')
  end
end
