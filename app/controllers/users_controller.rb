class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def index
    @users = User.order(:email)
    @users.each do |user|
      user.totalbal = user.total
    end
  end

  def create
    User.create(params[:user])
    @users = User.order(:email)
    respond_to do |format|
      format.html {redirect_to(users_path)}
    end
  end
end