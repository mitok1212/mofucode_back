class ApplicationController < ActionController::API
  before_action :authenticate_request

  def authenticate_request
    token = request.headers['Authorization']&.split(' ')&.last
    if token.blank?
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
end
