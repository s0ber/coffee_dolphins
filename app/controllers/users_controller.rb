class UsersController < ApplicationController
  def index
    @users = User.all
    respond_with(@users)
  end

  def new
  end

  def create
  end
end
