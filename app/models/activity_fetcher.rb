class ActivityFetcher

    HTTP_ERRORS = [
        EOFError,
        Errno::ECONNRESET,
        Errno::EINVAL,
        Net::HTTPBadResponse,
        Net::HTTPHeaderSyntaxError,
        Net::ProtocolError,
        Timeout::Error,
    ]

    include HTTParty
    base_uri 'https://api.github.com/users'

    attr_accessor :username, :activity
    def initialize(username)
        @username = username
    end

    def run
        return {
            error: "Hourly rate limit of 60 requests exceeded. Please try again later."
        } if rate_limit_exceeded
        begin
            get_response
        rescue *HTTP_ERRORS => e
            { error: e.message }
        end
    end

    def get_response
        response = self.class.get("/#{username}/events", options)
        if response.code == 304 # Not Modified response
            Rails.cache.fetch("#{username}/data") do
                # Re-send request if user's data was pushed out of
                # cache but ETag still exists
                Rails.cache.delete("#{username}/etag")
                response = self.class.get("/#{username}/events", options)
                handle_response(response)
            end
        else
            handle_response(response)
        end
    end

    def handle_response(response)
        update_rate_limit(response.headers)
        save_etag(response.headers)
        return_activities_or_error(response)
    end

    def options
        headers = { "User-Agent" => "Httparty" }
        if etag = Rails.cache.read("#{username}/etag")
            headers.merge!("If-None-Match" => etag)
        end
        { headers: headers }
    end

    private

    def return_activities_or_error(response)
        if response.code < 400
            Rails.cache.write("#{username}/data", response.parsed_response, expires_in: expires_in(response.headers))
            response.parsed_response
        else
            { error: response.parsed_response["message"] }
        end
    end

    def update_rate_limit(headers)
        Rails.cache.write("requests_remaining", headers["x-ratelimit-remaining"].to_i, expires_in: expires_in(headers).seconds)
    end

    def expires_in(headers)
        (headers["x-ratelimit-reset"].to_i - Time.current.utc.to_i).seconds
    end

    def save_etag(headers)
        Rails.cache.write("#{username}/etag", headers["etag"]) if headers["etag"]
    end

    def rate_limit_exceeded
        Rails.cache.read("requests_remaining") && Rails.cache.read("requests_remaining") <= 0
    end

end