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
    @user = User.create(params[:user])
    @users = User.order(:email)
    session[:user_id] = @user.id

    respond_to do |format|
      format.html {redirect_to(users_path)}
    end
  end
end