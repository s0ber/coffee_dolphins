class UsersController < ApplicationController
  def index
    @users = User.all
    @user = User.new
    respond_with(@users)
  end

  def new
  end

  def create
  end
end
