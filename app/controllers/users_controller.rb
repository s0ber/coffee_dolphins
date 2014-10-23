class UsersController < ApplicationController
  def index
    @users = User.active.decorate
    @user = User.new
    respond_with(@users)
  end

  def show
    @user = User.find(params[:id]).decorate
    render_partial('user', user: @user)
  end

  def create
    @user = User.create!(user_params).decorate
    render_partial('user', user: @user)
  end

  def edit
    @user = User.find(params[:id]).decorate
    respond_with(@user)
  end

  def update
    user = User.find(params[:id])
    user.update_attributes!(user_params)

    render json: {success: true}
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
