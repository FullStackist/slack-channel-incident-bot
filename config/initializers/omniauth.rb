require 'omniauth-slack'

Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth.config.logger = Rails.logger
  Rails.logger.info "Setting up OmniAuth with Slack provider"

  
  provider :slack, Rails.application.credentials.slack['client_id'], Rails.application.credentials.slack['client_secret'], scope: 'channels:manage,groups:write,im:write,
mpim:write,commands'
end
  