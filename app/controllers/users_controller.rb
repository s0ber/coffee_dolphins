class UsersController < ApplicationController
  def index
    @users = User.all
    @user = User.new
    respond_with(@users)
  end

  def new
  end

  def create
    @user = User.create!(user_params)
    respond_with(@user)
  end

private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
