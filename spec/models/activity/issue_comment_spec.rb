require 'rails_helper'

describe Activity::IssueComment do
    let(:payload) {
        ActiveSupport::HashWithIndifferentAccess.new({
            "action": "created",
            "issue": {
                "html_url": "https://github.com/bundler/bundler/pull/7088",
                "node_id": "MDExOlB1bGxSZXF1ZXN0MjY2MjMxOTkx",
                "title": "Bump version to 2.1.0.beta1.",
                "user": {
                    "login": "hsbt",
                    "id": 12301,
                    "node_id": "MDQ6VXNlcjEyMzAx",
                    "avatar_url": "https://avatars1.githubusercontent.com/u/12301?v=4",
                },
                "state": "open",
                "comments": 1,
                "created_at": "2019-04-01T13:04:20Z",
                "updated_at": "2019-04-01T23:10:00Z",
                "closed_at": nil,
                "author_association": "MEMBER",
                "pull_request": {
                    "url": "https://api.github.com/repos/bundler/bundler/pulls/7088",
                    "html_url": "https://github.com/bundler/bundler/pull/7088",
                    "diff_url": "https://github.com/bundler/bundler/pull/7088.diff",
                    "patch_url": "https://github.com/bundler/bundler/pull/7088.patch"
                }
            },
            "comment": {
                "html_url": "https://github.com/bundler/bundler/pull/7088#issuecomment-478779497",
                "id": 478779497,
                "user": {
                    "login": "colby-swandale",
                    "id": 996377,
                    "node_id": "MDQ6VXNlcjk5NjM3Nw==",
                    "avatar_url": "https://avatars0.githubusercontent.com/u/996377?v=4",
                },
                "created_at": "2019-04-01T23:10:00Z",
                "updated_at": "2019-04-01T23:10:00Z",
                "author_association": "MEMBER",
                "body": "This is the comment content..."
            }
        })
    }

    let(:activity) {
        data = get_data.merge("payload" => payload, "type" => "IssueCommentEvent")
        Activity::IssueComment.new(data)
    }

    it 'should display correct details (in markdown)' do
        expect(activity.details).to eq("Created comment on issue [Bump version to 2.1.0.beta1.](https://github.com/bundler/bundler/pull/7088):\n\"This is the comment content...\"\n")
    end

    it 'should have an issue title' do
        expect(activity.issue_title).to eq("Bump version to 2.1.0.beta1.")
    end

    it 'should have an issue url' do
        expect(activity.issue_url).to eq("https://github.com/bundler/bundler/pull/7088")
    end

    it 'should have a comment' do
        expect(activity.comment).to eq("This is the comment content...")
    end
end