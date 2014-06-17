class UsersController < ApplicationController
  # All user views reguire login, except those which handle login / new accounts
  skip_before_action :require_login, 
                     only: [:login, :logout, :post_login, :new, :create]

  # get /users
  def index
    @title  = "Index of users"
    @users  = User.all
  end

  # get /users/:id
  def show
    begin
      user = User.find( params[:id] )
      @title    = %Q|#{user.full_name}'s photos|
      @username = user.full_name
      @photos   = user.photos
    rescue ActiveRecord::RecordNotFound # catch invalid user ID
      @title = "Cannot find user"
      render_404
    end
  end

  # get /users/new
  def new
    @title = "Create new user account"
    @user  = User.new
  end

  # post /users
  def create
    @title = "New user validation"
    @user  = User.create( valid_params(params) )
    if @user.valid? then
      flash.notice = "Welcome, #{@user.first_name}!"
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      render action: "new"
    end
  end

  # get /users/login
  def login
    if session[:user_id] == nil then
      @title      = "Please log in!"
      @user       = User.new
      @user.login = flash[:login] # fine if nil
    else
      redirect_to user_path(@curr_user)
    end
  end

  # post /users/post_login
  def post_login
    user = User.find_by_login(params[:login])

    if user == nil # invalid username
      redirect_to login_users_path,
                  flash: { notice: "Invalid username!", login: params[:login] }

    elsif user.password_valid?( params[:password] )
      session[:user_id] = user.id
      redirect_to user_path(user)

    else # invalid password
      redirect_to login_users_path,
                  flash: { notice: "Invalid password!", login: params[:login] }
    end
  end

  # get /users/logout
  def logout
    reset_session
    flash.notice = "You are logged out"
    redirect_to login_users_path
  end

  private
  # Valid parameters for logging in / modifying users
  def valid_params(params)
    params.permit(:login, :first_name, :last_name, 
                  :password, :password_confirmation)
  end
end
