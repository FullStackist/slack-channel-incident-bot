require 'openssl'
require 'rack/utils'

class Auth::SlackCommandAuthService
    def initialize(raw_content, headers)
        @raw_content = raw_content
        @headers = headers
    end

    def verify_request?
        
        if beyond_timeout?
            return false
        end

        application_signature = app_hash_compute

        request_hash_compare(application_signature)

    end

    private

    def beyond_timeout?
        request_time = @headers['X-Slack-Request-Timestamp']
        time_difference = (Time.current - Time.at(request_time.to_i)).to_i.abs
        time_difference > (60 * 5)
    end

    def app_hash_compute
        base_signature = 'v0:' + @headers['X-Slack-Request-Timestamp'] + ":" + @raw_content

        hmac_utility = OpenSSL::HMAC.new(Rails.application.credentials.slack[:signing_secret], OpenSSL::Digest::SHA256.new)
        hmac_utility.update(base_signature)

        application_signature = "v0=" + hmac_utility.hexdigest
        application_signature
    end

    def request_hash_compare(application_signature)
        external_signature = @headers['x-slack-signature']
        Rack::Utils.secure_compare(application_signature, external_signature)
    end
end