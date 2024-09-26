class UsersController < ApplicationController
    def create
      @user = User.new(user_params)
      if @user.save
        session[:user_id] = @user.id  # ユーザー登録後に自動でログイン
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
  #ユーザー登録関連の処理