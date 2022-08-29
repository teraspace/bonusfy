class UsersController < ApplicationController
  before_action :authorized, only: [:auto_login], except: [:create]



  api :POST, '/users', 'Create an user'
  param :user, Hash do
    param :name, String, 'Name of the user'
    param :email, String, 'Email / username'
    param :password, String, 'Password'
  end
  def create
    @user = User.create(user_params)

    raise 'Invalid user' unless @user.valid?

    token = encode_token({ user_id: @user.id })
    render json: { user: @user, token: token }
  rescue StandardError => e
    errors_msg = @user&.errors
    errors_msg ||= e
    render json: { error: errors_msg }
  end

  api :POST, '/login', 'Generates auth token'
  def login
    @user = User.find_by(email: params[:email])

    raise 'Invalid email or password' unless @user && @user&.authenticate(params[:password])

    token = encode_token({ user_id: @user.id })
    render json: { name: @user.name, token: token, expiration: 24.hours.from_now }
  rescue StandardError => e
    render json: { error: e }
  end

  api :POST, '/auto_login', 'Token validation'
  def auto_login
    render json: @user
  rescue StandardError => e
    render json: { error: e }
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
