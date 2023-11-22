# app/controllers/users/omniauth_callbacks_controller.rb
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    user = User.from_omniauth(auth || request.env['omniauth.auth'])
    if user.present?
      sign_out_all_scopes
      render 'devise.omniauth_callback.success', kind: 'Google'
      sign_in_and_redirect user, event: :authentication
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
      render 'devise.omniauth_callback.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."

    end
  end

  private

  def auth
    @auth ||= request.env['omniauth.auth']
    render @auth
  end
  def failure
    redirect_to new_user_session_path
  end
end
