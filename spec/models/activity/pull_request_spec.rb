require 'rails_helper'

describe Activity::PullRequest do
    let(:payload) {
        ActiveSupport::HashWithIndifferentAccess.new({
            "action": "opened",
            "number": 7091,
            "pull_request": {
                "url": "https://api.github.com/repos/bundler/bundler/pulls/7091",
                "id": 266562404,
                "node_id": "MDExOlB1bGxSZXF1ZXN0MjY2NTYyNDA0",
                "html_url": "https://github.com/bundler/bundler/pull/7091",
                "number": 7091,
                "state": "open",
                "locked": false,
                "title": "Change info command spec to use `bundle info` instead of `bundle show`",
                "user": {
                    "login": "colby-swandale",
                    "id": 996377,
                    "node_id": "MDQ6VXNlcjk5NjM3Nw==",
                    "avatar_url": "https://avatars0.githubusercontent.com/u/996377?v=4",
                    "gravatar_id": "",
                    "url": "https://api.github.com/users/colby-swandale",
                    "html_url": "https://github.com/colby-swandale",
                    "type": "User",
                    "site_admin": false
                },
                "body": "Body of PR...",
                "created_at": "2019-04-02T09:36:31Z",
                "updated_at": "2019-04-02T09:36:31Z",
                "head": {
                    "label": "bundler:colby/fix-info-spec",
                    "ref": "colby/fix-info-spec",
                    "sha": "bfcb3997d54868074f85a7e9e07f3596f8ac1f44",
                    "user": {
                        "login": "bundler",
                        "id": 1137638,
                        "node_id": "MDEyOk9yZ2FuaXphdGlvbjExMzc2Mzg=",
                        "avatar_url": "https://avatars0.githubusercontent.com/u/1137638?v=4",
                        "type": "Organization",
                        "site_admin": false
                    },
                    "repo": {
                        "id": 488514,
                        "node_id": "MDEwOlJlcG9zaXRvcnk0ODg1MTQ=",
                        "name": "bundler",
                        "full_name": "bundler/bundler",
                        "private": false,
                        "owner": {
                            "login": "bundler",
                            "id": 1137638,
                            "node_id": "MDEyOk9yZ2FuaXphdGlvbjExMzc2Mzg=",
                            "avatar_url": "https://avatars0.githubusercontent.com/u/1137638?v=4",
                            "type": "Organization",
                            "site_admin": false
                        },
                        "html_url": "https://github.com/bundler/bundler",
                        "description": "Manage your Ruby application's gem dependencies",
                        "fork": false,
                        "created_at": "2010-01-26T00:46:38Z",
                        "updated_at": "2019-04-02T08:46:20Z",
                        "pushed_at": "2019-04-02T09:35:20Z",
                        "homepage": "https://bundler.io",
                        "size": 48424,
                        "stargazers_count": 4507,
                        "watchers_count": 4507,
                        "language": "Ruby",
                        "has_issues": true,
                        "has_projects": true,
                        "has_downloads": false,
                        "has_wiki": false,
                        "has_pages": true,
                        "forks_count": 2028,
                        "mirror_url": nil,
                        "archived": false,
                        "open_issues_count": 249,
                        "license": {
                            "key": "other",
                            "name": "Other",
                            "spdx_id": "NOASSERTION",
                            "url": nil,
                            "node_id": "MDc6TGljZW5zZTA="
                        },
                        "forks": 2028,
                        "open_issues": 249,
                        "watchers": 4507,
                        "default_branch": "master"
                    }
                },
                "base": {
                    "label": "bundler:master",
                    "ref": "master",
                    "sha": "d6f343cc5b69185c0bb45140d9e6b1fc4121688b",
                    "user": {
                        "login": "bundler",
                        "id": 1137638,
                        "node_id": "MDEyOk9yZ2FuaXphdGlvbjExMzc2Mzg=",
                        "avatar_url": "https://avatars0.githubusercontent.com/u/1137638?v=4"
                    },
                    "repo": {
                        "id": 488514,
                        "node_id": "MDEwOlJlcG9zaXRvcnk0ODg1MTQ=",
                        "name": "bundler",
                    }
                },
                "author_association": "MEMBER",
                "merged": false,
                "commits": 1,
                "additions": 1,
                "deletions": 1,
                "changed_files": 1
            }
        })
    }

    let(:activity) {
        data = get_data.merge("payload" => payload, "type" => "PullRequestEvent")
        Activity::PullRequest.new(data)
    }

    it 'should display correct details (in markdown)' do
        expect(activity.details).to eq("Opened pull request [Change info command spec to use `bundle info` instead of `bundle show`](https://github.com/bundler/bundler/pull/7091)\n")
    end

    it 'should have a url' do
        expect(activity.url).to eq("https://github.com/bundler/bundler/pull/7091")
    end

    it 'should have a title' do
        expect(activity.title).to eq("Change info command spec to use `bundle info` instead of `bundle show`")
    end
end