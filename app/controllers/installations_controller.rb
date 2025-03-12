require 'faraday'

class InstallationsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

    def success
        @installation = Installation.find(params[:id])
    end


    def create
        
        code = params[:code]
        state = params[:state]

        if params[:error]
          redirect_to root_path, alert: "Error during OAuth process: #{params[:error_description]}"
          return
        end

        client_id = Rails.application.credentials.slack['client_id']
        client_secret = Rails.application.credentials.slack['client_secret']
        redirect_uri = "https://slack-channel-incident-bot.onrender.com/installations/create"

        token_url = "https://slack.com/api/oauth.v2.access"
        token_creation_response = Faraday.post(token_url, {
          code: code,
          client_id: client_id,
          client_secret: client_secret,
          redirect_uri: redirect_uri
        })

        token_creation_result = JSON.parse(token_creation_response.body)

        if token_creation_result['ok']
          slack_workspace_id = token_creation_result['team']['id']
          slack_access_token = token_creation_result['access_token']

          @installation = Installation.find_or_create_by(slack_workspace_id: slack_workspace_id)
          @installation.update(slack_access_token: slack_access_token)

          if @installation.save
            redirect_to installation_success_path(@installation)
          else
            render :new, status: :unprocessable_entity
          end
        else
          puts token_creation_result
          render :new, status: :unprocessable_entity
        end

    end

end
