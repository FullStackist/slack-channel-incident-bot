# update incident status
# Send message of how long it took to get resolution

class Command::RootlyResolveService
    include SharedServiceLogic

    def initialize(command_params, swi)
        @workspace = command_params[:team_id]
        @channel_id = command_params[:channel_id]
        @response_url = command_params[:response_url]

        @slack_workspace_id = swi
    end

    def verify_command
        # Check if there's an incident corresponding to the channel
        incident_exists = Incident.exists?(channel: @channel_id, workspace: @workspace)
        Rails.logger.info incident_exists
        incident_exists
    end

    def call
        if verify_command
            incident_ref = update_with_status # update incident status
            resolution_time = determine_resolution_time(incident_ref)
            resolution_message = format_resolution_message(resolution_time)
            channel_visible_response(resolution_message, @response_url, @slack_workspace_id)
        else
            message_response("Resolve not allowed in channel: please only use command in incident channel", @response_url, @slack_workspace_id, "Error")
        end
    end

    private

    def update_with_status
        incident = Incident.find_by(channel: @channel_id, workspace: @workspace)
        incident.update(status: 'resolved')
        incident_ref = incident[:id]
        Rails.logger.info "update_with_status data: #{incident_ref}"
        incident_ref
    end

    def determine_resolution_time(incident_ref)
        incident = Incident.find(incident_ref)
        Rails.logger.info incident
        raw_difference = Time.current - incident[:created_at]
        Rails.logger.info raw_difference
        hour_difference = raw_difference / 1.hour
        difference_text = "#{hour_difference} hours"
    end

    def format_resolution_message(time_difference)
        raw_message = "Incident resolved - good work team! The approximate resolution time was: #{time_difference}"
        raw_message
    end
end