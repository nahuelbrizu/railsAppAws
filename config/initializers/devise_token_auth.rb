Rails.application.config.to_prepare do
  Devise::OmniauthCallbacksController.class_eval do
    def failure
      set_flash_message! :alert, :failure, kind: OmniAuth::Utils.camelize(failed_strategy.name), reason: failure_message
      redirect_to after_omniauth_failure_path_for(resource_name)
    end
  end
end
