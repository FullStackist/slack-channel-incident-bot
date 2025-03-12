require 'faraday'

class Interaction::RootlyDeclareModalSubmitService
    include SharedServiceLogic

    def initialize(incident_params, swi)
        Rails.logger.info incident_params
        @slack_team = incident_params["team"]["id"]
        @slack_username = incident_params["user"]["username"]
        @slack_userid = incident_params["user"]["id"]
        @interaction_data = incident_params["view"]["state"]["values"]
        Rails.logger.info @interaction_data
        @incident = nil
        @response_url = incident_params["response_urls"][0]["response_url"]
        Rails.logger.info "Interaction::RDMS responseurl = #{@response_url}"

        @slack_workspace_id = swi
    end

    def call
        # Persist to database
        create_record
        if @incident
            # Create slack channel
            create_slack_channel
        else
            # Cannot persist nor continue
            message_response("Could not create Incident nor Incident channel: please try again", @response_url, @slack_workspace_id, "Error")
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
        title = @interaction_data["incident_title_section"]["incident_title_input"]["value"]

        if !Incident.exists?(title: title, workspace: @slack_team)

            description_data = @interaction_data["incident_description_section"].present? ? @interaction_data["incident_description_section"]["incident_description_input"]["value"] : ""
            Rails.logger.info "@ISS: #{@interaction_data}"
            severity_data = @interaction_data["incident_severity_section"].present? ? @interaction_data["incident_severity_section"]["incident_severity_select"]["selected_option"]["value"] : ""

            @incident = Incident.new(
                title: title,
                description: description_data,
                severity: severity_data,
                workspace: @slack_team,
                creator: @slack_username,
                status: "Open"
            )

            @incident.save

        end
    end

    def create_slack_channel

        channel_name = @interaction_data["incident_title_section"]["incident_title_input"]["value"].downcase + "_incident"
        channel_name = transform_for_slack_channel_name(channel_name)
        channel_object = { name: channel_name }

        Rails.logger.info @slack_workspace_id

        bearer_token = retrieve_slack_access_token(@slack_workspace_id)

        response = Faraday.post('https://slack.com/api/conversations.create') do |req|
            req.headers['Authorization'] = "Bearer #{bearer_token}"
            req.headers['Content-Type'] = "application/json"
            req.body = channel_object.to_json
        end

        response_body = JSON.parse(response.body)
        Rails.logger.info response

        if !response.success?
            message_response(response_body["error"], @response_url, @slack_workspace_id, "Error")
        else
            update_with_channel(response_body["channel"]["id"])
            message_response(response_body["error"], @response_url, @slack_workspace_id)
        end

    end

end