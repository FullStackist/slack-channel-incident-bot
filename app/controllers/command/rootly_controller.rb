module Command

  class RootlyController < ApplicationController
    skip_before_action :verify_authenticity_token # requests are coming from the Slack Platform, so, there is no browser security context in which CSRF is a concern
    before_action :set_command_session, only: [:handle_command, :handle_interaction]

    def handle_command

      # Verify request comes from Slack (authentication) and is permitted to do so (authorization)   
      auth_service = Auth::SlackCommandAuthService.new(request.body.read, request.headers)

      unless auth_service.verify_request?
        render json: { text: 'Unauthorized request' }, status: :ok
      end

      route_service = Route::RootlyCommandRouteService.new(slack_command_params, session[:slack_workspace_id])

      ##result = route_service.call
      ##render json: { text: 'Command successful!'}, status: :ok
      begin
        result = route_service.call
        render json: { text: "#{result}"}, status: :ok # Acknowledgement response
      rescue => e
        render json: { text: "#{e}" }, status: :ok # Acknowledgement response, enriched with error data
      end
    end

    def handle_interaction

      # Acknowledgement response
      head :ok

      auth_service = Auth::SlackCommandAuthService.new(request.body.read, request.headers)

      unless auth_service.verify_request?
        render json: { text: 'Unauthorized request' }, status: :ok
      end

      route_service = Route::RootlyInteractionRouteService.new(slack_interaction_params, session[:slack_workspace_id])
      begin
        result = route_service.call
        render json: { text: "#{result}"}, status: :ok # Acknowledgement response
      rescue => e
        puts e
      end
    end

    private

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
        :api_app_id,
        :is_enterprise_install
      )
    end
  
    def slack_interaction_params
      JSON.parse(params[:payload])
    end
  
    def set_command_session
      if params["payload"].present?
        session[:slack_workspace_id] = JSON.parse(params["payload"])["team"]["id"]
      else
        session[:slack_workspace_id] = slack_command_params[:team_id]
      end
    end

  end

end
