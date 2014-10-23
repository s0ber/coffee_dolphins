class UsersController < ApplicationController
  def index
    @users = User.active
    @user = User.new
    respond_with(@users)
  end

  def create
    @user = User.create!(user_params)
    render_partial('user', user: @user)
  end

  def edit
    @user = User.find(params[:id])
    respond_with(@user)
  end

  def update

  end

  def destroy
    User.find(params[:id]).destroy
    render json: {success: true}
  end

private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
