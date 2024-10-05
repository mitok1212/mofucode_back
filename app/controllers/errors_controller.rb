# app/controllers/errors_controller.rb
class ErrorsController < ApplicationController
    # 404エラー
    def not_found
        render json: { error: 'Resource not found' }, status: :not_found
    end
  
    # 500エラー
    def internal_server_error
        render json: { error: 'Internal Server Error' }, status: :internal_server_error
    end
    def unprocessable_entity
        render json: { error: 'Unprocessable entity' }, status: :unprocessable_entity
    end
end
  