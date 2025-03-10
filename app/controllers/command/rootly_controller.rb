module Command

  class RootlyController < ApplicationController
    skip_before_action: :verify_authenticity_token # requests are coming from the Slack Platform, so, there is no browser security context in which CSRF is a concern

    def handle_command

      # Verify request comes from Slack (authentication) and is permitted to do so (authorization)   
      auth_service = SlackCommandAuthService.new()

      unless auth_service.verify_request?
        render json: { text: 'Unauthorized request' }, status: :ok
      end

      route_service = RootlyCommandRouteService.new(slack_command_params)
      begin
        result = route_service.call
        render json: { text: 'Command successful!'}, status: :ok # Acknowledgement response
      rescue => e
        render json: { text: "#{e}" }, status: :ok # Acknowledgement response, enriched with error data
      end
    end

    def handle_interaction

      # Acknowledgement response
      head :ok

      auth_service = SlackCommandAuthService.new()

      unless auth_service.verify_request?
        render json: { text: 'Unauthorized request' }, status: :ok
      end

      route_service = RootlyInteractionRouteService.new(slack_interaction_params)
      begin
        route_service.call
      rescue => e
        render json: { text: "#{e}" }, status: :ok
      end
    end

  end

  def slack_command_params
    params.permit(
      :token,
      :team_id,
      :team_domain,
      :enterprise_id,
      :enterprise_name,
      :channel_id,
      :channel_name,
      :user_id,
      :user_name,
      :command,
      :text,
      :response_url,
      :trigger_id,
      :api_app_id
    )
  end

  def slack_interaction_params
    params.permit(
      :type,
      :team,
      :view,
      user: [:id, :username],
      actions: [
        :action_id,
        :block_id,
        :value,
        :selected_option
      ],
      response_urls: []
    )
  end

end
