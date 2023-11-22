# frozen_string_literal: true
#app/controllers/users/sessions_controller.rb
# require 'firebase-admin'
require 'firebase-admin'

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end


  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || create
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end
  def create
    user_params = user_params_from_frontend # Define cómo obtienes los datos del frontend

      # Initialize Firebase Admin SDK with user's credentials
      firebase_admin = Firebase::Admin::SDK.new(
        credential: Firebase::Admin::Credentials.from_service_account_hash(
          api_key: user.firebase_api_key,
          auth_domain: user.firebase_auth_domain,
          project_id: user.firebase_project_id,
          private_key: user.firebase_private_key,
          client_email: user.firebase_client_email
        )
      )
    begin
      decoded_token = firebase_admin.auth.verify_id_token(user_params[:access_token])
      user_id = decoded_token['uid']

      # Verifica si el usuario con user_id existe en tu base de datos
      user = User.find_by(uid: user_id)

      if user
        # Autentica al usuario en tu aplicación
        sign_in(user)
        render json: { user: user, message: 'Inicio de sesión exitoso' }
      else
        # Usuario no encontrado
        render json: { error: 'Usuario no encontrado' }, status: :unauthorized
      end
    rescue Firebase::Admin::Auth::IDTokenVerificationError => e
      # Error al verificar el token
      render json: { error: 'Token de acceso no válido' }, status: :unauthorized
    end
  end

  private

  def user_params_from_frontend
    params.permit(:access_token, :email, :displayName, :photoURL, :uid, :providerId)
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  #def destroy(token)
  #  super
  #end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
