class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create] # Ensure this is placed correctly

  def create
    p user_params
    @user = User.new(user_params)
    if @user.save
      token = generate_jwt_token(@user.id)  # Generate JWT token
      render json: { message: 'User created and logged in', user: @user, token: token }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password_digest, :age, :weight, :height, :gender)
  end

  # JWT token generation method
  def generate_jwt_token(user_id)
    JWT.encode({ user_id: user_id, exp: 24.hours.from_now.to_i }, Rails.application.credentials.secret_key_base)
  end
end
