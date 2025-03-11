require 'faraday'

class RootlyDeclareModalSubmitService
    include SharedServiceLogic

    def initialize(incident_params)
        @slack_team = incident_params[:team][:id]
        @slack_username = incident_params[:user][:username]
        @slack_userid = incident_params[:user][:id]
        @interaction_data = incident_params[:view][:state][:values]
        @incident = nil
        @response_url = incident_params[:response_urls][:response_url]
    end

    def call
        # Persist to database
        create_record
        if @incident
            # Create slack channel
            create_slack_channel
        else
            # Cannot persist nor continue
            message_response("Could not create Incident nor Incident channel: please try again", "Error")
        end

        end
    end

    private

    def update_with_channel(channel_id)
        external_id = @slack_userid + "_" + channel_id
        persisted_incident = Incident.find(@incident[:id])
        persisted_incident.update(channel: channel_id, eid: external_id)
    end

    def create_record
        # Check if incident already exists with same title for the same workspace.
        if !Incident.exists?(title: @interaction_data[:incident_title_section][:incident_title_input][:value], workspace: @slack_team)

            description_data = @interaction_data[:incident_description_section].present? @interaction_data[:incident_description_section][:incident_description_input][:value] : ""
            severity_data = @interaction_data[:incident_severity_section].present? || @interaction_data[:incident_severity_section][:incident_severity_select][:value] : ""

            @incident = Incident.new(
                title: @interaction_data[:incident_title_section][:incident_title_input][:value],
                description: description_data,
                severity: severity_data,
                workspace: @slack_team,
                creator: @slack_username,
                status: "Open"
            )

        end
    end

    def create_slack_channel

        channel_name = @interaction_data[:incident_title_section][:incident_title_input][:value] + "_incident"
        channel_object = { name: channel_name }

        bearer_token = retrieve_slack_access_token

        response = Faraday.post('https://slack.com/api/conversations.create') do |req|
            req.headers['Authorization'] = 'Bearer #{bearer_token}'
            req.headers['Content-Type'] = "application/json"
            req.body = channel_object.to_json
        end

        if !response.success?
            message_response(response.json[:error], @response_url, "Error")
        else
            update_with_channel(response.json[:channel][:id])
            message_response(response.json[:error], @response_url)
        end

    end

end