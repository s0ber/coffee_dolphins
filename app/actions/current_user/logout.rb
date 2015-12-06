class CurrentUser::Logout < AStream::BaseAction
  permit_resource true

  def perform_update(performer, query)
    controller.logout
    {status: :ok}
  end
end
