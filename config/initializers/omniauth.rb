OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "776737631794-mcjh608vgpfe581mqeu3taqaaej7ig1u.apps.googleusercontent.com", "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",
           scope: 'email,profile',
           access_type: 'offline'
end
# config/initializers/omniauth.rb

