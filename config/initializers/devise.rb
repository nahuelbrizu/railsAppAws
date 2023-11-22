# frozen_string_literal: true

Devise.setup do |config|

  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'
  config.navigational_formats = [:json]

  require 'devise/orm/active_record'
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]

config.omniauth :google_oauth2,
                '776737631794-mcjh608vgpfe581mqeu3taqaaej7ig1u.apps.googleusercontent.com',
                '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',{}

  #config.omniauth :google_oauth2, '772918967244-k93kvjnb41dfhnp477vo2hgmafvi29i1.apps.googleusercontent.com', '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',
  #                redirect_uri: 'http://localhost:3000/users/auth/google_oauth2/callback',
  #                strategy_class: OmniAuth::Strategies::GoogleOauth2


  config.omniauth :facebook, '694765802519365', 'a0544e684b7e9caf2875a9b5f5aa5eec', callback_url: 'http://localhost:3000/users/auth/google_oauth2/callback'

  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 12
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other


end
