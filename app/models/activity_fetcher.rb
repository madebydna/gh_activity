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
        begin
            response = self.class.get("/#{username}/events", {
                headers: {"User-Agent" => "Httparty"}
            })
            return_activities_or_error(response)
        rescue *HTTP_ERRORS => e
            { error: e.message }
        end
    end

    private

    def return_activities_or_error(response)
        if response.code < 400
            response.parsed_response
        else
            { error: response.parsed_response["message"] }
        end
    end

end