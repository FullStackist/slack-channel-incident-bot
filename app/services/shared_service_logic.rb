require 'faraday'

module SharedServiceLogic

    def message_response(body, hook, pretext="Success",)
        ephermal_message = pretext == "Success" ? pretext : body
        Faraday.post(hook) do |req|
            req.headers['Authorization'] = 'Bearer #{Rails.application.credentials.slack.api[:bearer_token]}'
            req.headers['Content-Type'] = "application/json"
            req.body = { "text": ephermal_message }.to_json
        end
    end

    def channel_visible_response(channel_message, hook)
        Faraday.post(hook) do |req|
            req.headers['Authorization'] = 'Bearer #{Rails.application.credentials.slack.api[:bearer_token]}'
            req.headers['Content-Type'] = "application/json"
            req.body = { "text": channel_message, "response_type": "in_channel" }.to_json
        end
    end

end