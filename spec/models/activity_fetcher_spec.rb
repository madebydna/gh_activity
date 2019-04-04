require 'rails_helper'

describe ActivityFetcher do
    describe '#run' do
        it "should return array of activities for active user" do
            result = [
                {"id": "9361428270", "type": "IssueCommentEvent"},
                {"id": "9361428271", "type": "PushEvent"},
                {"id": "9361428272", "type": "PullRequestEvent"}
            ]

            stub_github_api_request(username: "mojombo", result: result.to_json)

            af = ActivityFetcher.new("mojombo")
            expect(af.run).to match [
                a_hash_including('type' => 'IssueCommentEvent'), a_hash_including('type' => 'PushEvent'),
                a_hash_including('type' => 'PullRequestEvent')
            ]
        end

        it "should return empty array of activities for inactive user" do
            result = []
            stub_github_api_request(username: "madebydna", result: result.to_json)
            af = ActivityFetcher.new("madebydna")
            expect(af.run).to be_empty
        end

        it "should return error when user is not found" do
            result = { message: "Not found" }.to_json
            stub_github_api_request(username: "foobar", result: result, code: 404)

            af = ActivityFetcher.new("foobar")
            expect(af.run).to eq({error: "Not found"})
        end

        it "should handle network errors gracefully" do
            stub_request(:get, ActivityFetcher.base_uri + "/foobar/events").to_raise(Net::HTTPBadResponse.new("bad response"))

            af = ActivityFetcher.new("foobar")
            expect(af.run).to eq({error: "bad response"})
        end
    end

    def stub_github_api_request(username:, result:, code: 200)
        stub_request(:get, ActivityFetcher.base_uri + "/#{username}/events").to_return(body: result, status: code, headers: {"Content-Type" => "application/json"})
    end
end