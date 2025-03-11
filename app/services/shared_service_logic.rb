require 'faraday'

module SharedServiceLogic

    def retrieve_slack_access_token
        installation = Installation.find_by(slack_workspace_id: session[:slack_workspace_id])
        access_token = installation.slack_access_token
        access_token
    end

    def message_response(body, hook, pretext="Success")
        bearer_token = retrieve_slack_access_token
        ephermal_message = pretext == "Success" ? pretext : body

        Faraday.post(hook) do |req|
            req.headers['Authorization'] = 'Bearer #{bearer_token}'
            req.headers['Content-Type'] = "application/json"
            req.body = { "text": ephermal_message }.to_json
        end
    end

    def channel_visible_response(channel_message, hook)
        bearer_token = retrieve_slack_access_token

        Faraday.post(hook) do |req|
            req.headers['Authorization'] = 'Bearer #{bearer_token}'
            req.headers['Content-Type'] = "application/json"
            req.body = { "text": channel_message, "response_type": "in_channel" }.to_json
        end
    end

end