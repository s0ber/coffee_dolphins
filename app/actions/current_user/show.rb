class CurrentUser::Show < AStream::BaseAction
  safe_attributes :full_name
  permit_resource true

  def perform_read(performer, query)
    controller.current_user
  end
end
