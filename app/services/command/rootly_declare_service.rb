require 'faraday'

class RootlyDeclareService
    def initialize(trigger_id, title)
        @slack_trigger_id = trigger_id
        @incident_title = title
    end

    def call
        incident_modal = Command::Rootly::IncidentModalView.new(@incident_title).render
        view_object = compose_view_object(incident_modal)

        response = Faraday.post('https://slack.com/api/views.open') do |req|
            req.headers['Authorization'] = 'Bearer #{Rails.application.credentials.slack.api[:bearer_token]}'
            req.headers['Content-Type'] = "application/json"
            req.body = view_object.to_json
        end

        raise "Could not open modal: please try again" unless response.success?

        response
    end

    private

    def compose_view_object(core_modal)
        {
            "trigger-id": @slack_trigger_id,
            "view": core_modal
        }
    end

    #create modal content
    #open modal

    ## for service receiving final incident submission
    #store in incidents table

    #create slack channel
end