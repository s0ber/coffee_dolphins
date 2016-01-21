class CurrentUser::Login < AStream::BaseAction
  safe_attributes :full_name
  permit_resource true

  def perform_update(performer, query)
    user = User.new(user_params(query))
    @user = controller.login(user.email, user.password, user.remember_me)

    if @user
      AStream::Response.new(body: @user, message: 'Вы успешно вошли на сайт.')
    else
      AStream::Response.new(status: :unauthorized)
    end
  end

  def user_params(query)
    query.permit(:email, :password, :remember_me)
  end
end
