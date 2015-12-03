class CurrentUser::Logout < AStream::BaseAction
  safe_attributes []
  permit_resource true

  def perform_read(performer, query)
    {status: :ok}
  end

  def perform_update(performer, query)
    controller.logout
    {status: :ok}
  end
end
