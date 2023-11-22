# frozen_string_literal: true
#app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]



    def create
      user_params = user_params_from_frontend # Define cómo obtienes los datos del frontend

      firebase_admin = Firebase::Admin::SDK.new(
        credential: Firebase::Admin::Credentials.from_file('config/firebase_setting.json')
      )

      begin
        decoded_token = firebase_admin.auth.verify_id_token(user_params[:access_token])
        user_id = user_params['uid']

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
      params.require(:user).permit(:email, :displayName, :photoURL, :uid, :providerId)
    end



  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_params_from_frontend])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:user_params_from_frontend])
  end

end
