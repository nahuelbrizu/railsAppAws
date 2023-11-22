# app/controllers/authentication_controller.rb
class AuthenticationController < ApplicationController
  def authenticate
    token = request.headers['Authorization']&.split('Bearer ')&.last
    if token
      user = decode_token(token)
      if user

        render json: user
      else
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { error: 'Token not provided' }, status: :unauthorized
    end
  end

  private

  def decode_token(token)
    begin
      # Implement your JWT decoding logic here
      decoded = JWT.decode(token, ENV['SECRET_KEY'], true, algorithm: 'HS256')
      return User.find(decoded[0]['user_id'])
    rescue JWT::DecodeError
      return nil
    end
  end
end
