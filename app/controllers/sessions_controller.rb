require 'jwt'

class SessionsController < ApplicationController
  def create
    token = params[:token] # You'll need to handle this based on your front-end's way of sending the token.

    # Verify the token (e.g., using Firebase Admin SDK, JWT libraries, etc.)
    user_data = verify_token(token)

    if user_data
      user = User.find_or_create_by(email: user_data['email']) # Adjust this based on your user data
      sign_in(user) # This sets up a session for the user

      # Generate a new token (e.g., JWT) to send back to the client for future authentication
      new_token = generate_new_token(user)

      render json: { user: user, token: new_token }
    else
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end

  private

  # Implement your token verification logic here (e.g., Firebase or JWT validation).
  # Verify a token, decode it, and return the user data
  def verify_token(token)
    begin
      # Verify and decode the token using Firebase Admin SDK or a JWT library
      decoded_token = FirebaseAdmin::Auth.verify_id_token(token)

      # Token is valid, and `decoded_token` contains user information
      user_id = decoded_token['uid']

      # You can retrieve additional user data as needed from `decoded_token`

      # Return user data
      user_data = {
        uid: user_id,
        email: decoded_token['email'],
        # Add other user attributes you want to return
      }

      return user_data
    rescue FirebaseAdmin::Auth::RevokedIdTokenError, FirebaseAdmin::Auth::InvalidIdTokenError
      # Token is invalid or has expired
      return nil
    end
  end

  # Generate a new token for the user (e.g., JWT)
  def generate_new_token(user)
    # Implement your token generation logic here using a JWT library
    payload = {
      user_id: user.id,
      email: user.email,
      # Add other user attributes you want to include in the token
    }

    secret_key = Rails.application.credentials.secret_key_base
    # Replace 'secret_key' with the actual key you use for signing JWTs

    token = JWT.encode(payload, secret_key, 'HS256')

    return token
  end

  def decode_token(token)
    secret_key = 'your_secret_key_here'
    begin
      decoded = JWT.decode(token, secret_key, true, algorithm: 'HS256')
      return User.find(decoded[0]['user_id'])
    rescue JWT::DecodeError
      return nil
    end
  end
end
