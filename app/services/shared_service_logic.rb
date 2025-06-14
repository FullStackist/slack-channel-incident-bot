require 'faraday'

module SharedServiceLogic

    def transform_for_slack_channel_name(input)
        transformed = input.downcase
        transformed = transformed.gsub(/[^a-z0-9_-]/, '')
        transformed = transformed[0, 80]
        
        transformed
      end

    def retrieve_slack_access_token(slack_workspace_id)
        installation = Installation.find_by(slack_workspace_id: slack_workspace_id)
        access_token = installation.slack_access_token
        access_token
    end

    def message_response(body, hook, swi, pretext="Success")
        bearer_token = retrieve_slack_access_token(swi)
        ephermal_message = pretext == "Success" ? pretext : body

        response = Faraday.post(hook) do |req|
            req.headers['Authorization'] = "Bearer #{bearer_token}"
            req.headers['Content-Type'] = "application/json"
            req.body = { "text": ephermal_message }.to_json
        end

        raise "Error: operation failed" unless response.success?

        body
    end

    def channel_visible_response(channel_message, hook, swi)
        bearer_token = retrieve_slack_access_token(swi)

        response = Faraday.post(hook) do |req|
            req.headers['Authorization'] = "Bearer #{bearer_token}"
            req.headers['Content-Type'] = "application/json"
            req.body = { "text": channel_message, "response_type": "in_channel" }.to_json
        end

        raise "Error: operation failed" unless response.success?

        channel_message
    end

end