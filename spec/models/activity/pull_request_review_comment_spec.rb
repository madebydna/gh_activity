require 'rails_helper'

describe Activity::PullRequestReviewComment do
    let(:payload) {
        ActiveSupport::HashWithIndifferentAccess.new({
            "action": "created",
            "comment": {
                "html_url": "https://github.com/bundler/bundler/pull/6957#discussion_r271579331",
                "pull_request_review_id": 222005712,
                "id": 271579331,
                "node_id": "MDI0OlB1bGxSZXF1ZXN0UmV2aWV3Q29tbWVudDI3MTU3OTMzMQ==",
                "path": "spec/commands/binstubs_spec.rb",
                "position": nil,
                "original_position": 51,
                "commit_id": "0b8223ab5f28c0e80c3b6384da24eadf57de9fec",
                "original_commit_id": "f570bf3b9a78b1f87fe878e96e733f536f3983c9",
                "user": {
                    "login": "colby-swandale",
                    "id": 996377,
                    "node_id": "MDQ6VXNlcjk5NjM3Nw==",
                    "avatar_url": "https://avatars0.githubusercontent.com/u/996377?v=4",
                    "type": "User",
                    "site_admin": false
                },
                "body": "It's required but the merge was a bit weird i think as well. I've made a new commit to fix this up.",
                "created_at": "2019-04-03T05:01:42Z",
                "updated_at": "2019-04-03T05:01:43Z",
                "html_url": "https://github.com/bundler/bundler/pull/6957#discussion_r271579331",
                "author_association": "MEMBER",
            },
            "pull_request": {
                "url": "https://api.github.com/repos/bundler/bundler/pulls/6957",
                "id": 251775358,
                "node_id": "MDExOlB1bGxSZXF1ZXN0MjUxNzc1MzU4",
                "html_url": "https://github.com/bundler/bundler/pull/6957",
                "state": "open",
                "title": "Merge 2-0-stable into master",
                "user": {
                    "login": "colby-swandale",
                    "id": 996377,
                },
                "body": "This PR contains the merge of `2-0-stable` to `master`",
                "created_at": "2019-02-10T23:24:49Z",
                "updated_at": "2019-04-03T05:01:42Z",
                "closed_at": nil,
                "merged_at": nil,
                "merge_commit_sha": "997f3ef274d7a5b4aa95694e12e47baadac1a812",
                "assignee": nil,
                "assignees": [],
                "requested_reviewers": [],
                "requested_teams": [],
                "labels": [],
                "milestone": nil,
            }
        })
    }

    let(:activity) {
        data = get_data.merge("payload" => payload, "type" => "PullRequestReviewCommentEvent")
        Activity::PullRequestReviewComment.new(data)
    }

    it 'should display correct details (in markdown)' do
        expect(activity.details).to eq("Left [comment](https://github.com/bundler/bundler/pull/6957#discussion_r271579331) on open pull request [Merge 2-0-stable into master](https://github.com/bundler/bundler/pull/6957)\n")
    end

    it 'should have an comment url' do
        expect(activity.comment_url).to eq("https://github.com/bundler/bundler/pull/6957#discussion_r271579331")
    end

    it 'should have a PR state' do
        expect(activity.pr_state).to eq("open")
    end

    it 'should have a PR url' do
        expect(activity.pr_url).to eq("https://github.com/bundler/bundler/pull/6957")
    end

    it 'should have a PR title' do
        expect(activity.pr_title).to eq("Merge 2-0-stable into master")
    end
end