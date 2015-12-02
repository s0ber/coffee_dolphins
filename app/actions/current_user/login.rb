class CurrentUser::Login < AStream::BaseAction
  query_params :email, :password, :remember_me
  safe_attributes :full_name
  permit_resource true

  def perform_read(performer, query)
    user = User.new(query)
    @user = controller.login(user.email, user.password, user.remember_me)

    {status: @user ? :ok : :unauthorized}
  end

  def perform_update(performer, query)
    [@user]
  end
end
