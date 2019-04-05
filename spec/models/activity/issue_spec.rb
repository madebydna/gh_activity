require 'rails_helper'

describe Activity::Issue do
    let(:payload) {
        ActiveSupport::HashWithIndifferentAccess.new({
            "action": "closed",
            "issue": {
                "url": "https://api.github.com/repos/bundler/bundler/issues/7048",
                "html_url": "https://github.com/bundler/bundler/issues/7048",
                "id": 422220761,
                "node_id": "MDU6SXNzdWU0MjIyMjA3NjE=",
                "number": 7048,
                "title": "Unable to run my project on circle ci",
                "user": {
                    "login": "Paluck29",
                    "id": 32965313,
                    "node_id": "MDQ6VXNlcjMyOTY1MzEz",
                    "avatar_url": "https://avatars1.githubusercontent.com/u/32965313?v=4",
                    "type": "User",
                    "site_admin": false
                },
                "state": "closed",
                "locked": false,
                "assignee": nil,
                "assignees": [],
                "milestone": nil,
                "comments": 2,
                "created_at": "2019-03-18T13:34:52Z",
                "updated_at": "2019-03-30T09:14:46Z",
                "closed_at": "2019-03-30T09:14:46Z",
                "author_association": "NONE",
                "body": "Issue Body"
            }
        })
    }

    let(:activity) {
        data = get_data.merge("payload" => payload, "type" => "IssuesEvent")
        Activity::Issue.new(data)
    }

    it 'should display correct details (in markdown)' do
        expect(activity.details).to eq("Closed [issue](https://github.com/bundler/bundler/issues/7048) \"Unable to run my project on circle ci\"\n")
    end

    it 'should have an issue title' do
        expect(activity.issue_title).to eq("Unable to run my project on circle ci")
    end

    it 'should have an issue url' do
        expect(activity.issue_url).to eq("https://github.com/bundler/bundler/issues/7048")
    end
end