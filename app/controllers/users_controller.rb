class UsersController < ApplicationController
 #ユーザー登録処理
    def create
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id  #auto_login
        render json: { message: 'User created and logged in', user: @user }, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:username, :email, :password, :age, :weight, :height, :gender)
    end
  
end
