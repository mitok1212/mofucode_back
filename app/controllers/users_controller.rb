class UsersController < ApplicationController
  #protect_from_forgery # 追記
 #skip_before_action :verify_authenticity_token, only: [:create] # CSRFskip
 skip_before_action :authenticate_request, only: [:csrf_token]
 #user-touroku
    def create
      @user = User.new(user_params)
      if @user.save
       # session[:user_id] = @user.id  #auto_login
       token = generate_jwt_token(@user.id)  # Generate JWT token
        render json: { message: 'User created and logged in', user: @user }, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    #CSRFtoken
    def csrf_token
      render json: { csrf_token: form_authenticity_token }
    end
  
    private
  
    def user_params
      params.require(:user).permit(:username, :email, :password, :age, :weight, :height, :gender)
    end

     # JWT token generation method
  def generate_jwt_token(user_id)
    JWT.encode({ user_id: user_id, exp: 24.hours.from_now.to_i }, Rails.application.secrets.secret_key_base)
  end
  
end
