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

    describe 'caching for rate limit and etags' do
        let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
        let(:cache) { Rails.cache }
        let(:result) { [{foo: "bar"}] }

        before do
            allow(Rails).to receive(:cache).and_return(memory_store)
            Rails.cache.clear
        end

        it "should cache user's ETag and data" do
            stub_github_api_request_with_headers(username: "mojombo", result: result.to_json)
            ActivityFetcher.new("mojombo").run
            expect(cache.read("mojombo/etag")).to eq("12345abcd1234")
            expect(cache.read("mojombo/data")).to match [
                a_hash_including('foo' => 'bar')
            ]
        end

        it "should cache number of requests remaining" do
            stub_github_api_request_with_headers(username: "mojombo", result: result.to_json)
            ActivityFetcher.new("mojombo").run
            expect(cache.read("requests_remaining")).to eq(59)
        end

        it "should not do a request if no requests remaining" do
            cache.write("requests_remaining", 0)
            af = ActivityFetcher.new("mojombo")
            expect(af.run).to eq({error: "Hourly rate limit of 60 requests exceeded. Please try again later."})
        end

        it "should return cached data if API returns 304 Not Modified" do
            cache.write("mojombo/data", result)
            cache.write("mojombo/etag", "1234abc")
            stub_request(:get, ActivityFetcher.base_uri + "/mojombo/events").to_return(body: [], status: 304, headers: { "Content-Type" => "application/json", "Etag" => "1234abc"})

            af = ActivityFetcher.new("mojombo")
            expect(af.run).to eq(result)
        end

        it "should re-query API when 304 and cached data not available" do
            stub_request(:get, ActivityFetcher.base_uri + "/mojombo/events")
            .to_return(body: [], status: 304, headers: { "Content-Type" => "application/json", "Etag" => "1234abc"})
            .to_return(body: result.to_json, status: 200, headers: { "Content-Type" => "application/json", "Etag" => "12345abcd1234", "X-RateLimit-Limit" => 60, "X-RateLimit-Remaining" => 59, "X-RateLimit-Reset" => (Time.now + 1.hour).to_i})

            af = ActivityFetcher.new("mojombo")
            expect(af.run).to match [a_hash_including('foo' => 'bar')]
        end
    end

    def stub_github_api_request(username:, result:, code: 200)
        stub_request(:get, ActivityFetcher.base_uri + "/#{username}/events").to_return(body: result, status: code, headers: {"Content-Type" => "application/json"})
    end

    def stub_github_api_request_with_headers(username:, result:, code: 200)
        stub_request(:get, ActivityFetcher.base_uri + "/#{username}/events").to_return(body: result, status: code, headers: {
            "Content-Type" => "application/json",
            "Etag" => "12345abcd1234",
            "X-RateLimit-Limit" => 60,
            "X-RateLimit-Remaining" => 59,
            "X-RateLimit-Reset" => (Time.now + 1.hour).to_i})
    end
end