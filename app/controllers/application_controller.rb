"""class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    token = request.headers['Authorization']&.split(' ')&.last
    if token.nil?
      return render json: { error: 'Token not provided' }, status: :unauthorized
    end

    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
      @current_user = User.find(decoded_token['user_id'])
    rescue JWT::ExpiredSignature
      render json: { error: 'Token has expired' }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { error: 'Invalid token' }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'User not found' }, status: :unauthorized
    end
  end
end"""
class ApplicationController < ActionController::Base
  #protect_from_forgery with: :null_session #追加
  skip_before_action :verify_authenticity_token
  before_action :authenticate_request

  private

  def authenticate_request
    token = request.headers['Authorization']&.split(' ')&.last
    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base)
      @current_user = User.find(decoded_token[0]['user_id'])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
