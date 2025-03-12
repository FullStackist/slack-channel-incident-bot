require 'faraday'

class Command::RootlyDeclareService
    include SharedServiceLogic

    def initialize(trigger_id, title, swi)
        @slack_trigger_id = trigger_id
        @incident_title = title
        @slack_workspace_id = swi
    end

    def call
        incident_modal = Command::Modal::IncidentModalView.new(@incident_title).render
        view_object = compose_view_object(incident_modal)

        bearer_token = retrieve_slack_access_token(@slack_workspace_id)
        Rails.logger.info "FROM CMD::RDS #{view_object}"

        response = Faraday.post('https://slack.com/api/views.open') do |req|
            req.headers['Authorization'] = "Bearer #{bearer_token}"
            req.headers['Content-Type'] = "application/json; charset=utf-8"
            req.body = view_object.to_json
        end

        Rails.logger.info "Response body: #{response.body}"
        Rails.logger.info view_object

        raise "Could not open modal: please try again" unless response.success?

        "You have begun the incident-creation process."
    end

    private

    def compose_view_object(core_modal)
        {
            "trigger_id": @slack_trigger_id,
            "view": core_modal
        }
    end

    #create modal content
    #open modal

    ## for service receiving final incident submission
    #store in incidents table

    #create slack channel
end