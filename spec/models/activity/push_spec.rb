require 'rails_helper'

describe Activity::Push do
    let(:payload) {
        ActiveSupport::HashWithIndifferentAccess.new({
            "push_id": 3463289136,
            "size": 1,
            "distinct_size": 1,
            "ref": "refs/heads/colby/bundler-2-merge",
            "head": "c70d3aa82857bbe09b9f9ffdc5ba106bd56ecf38",
            "before": "24c0bf242a4e7e60570c6c4569047e67c9db2eae",
            "commits": [
                {
                    "sha": "c70d3aa82857bbe09b9f9ffdc5ba106bd56ecf38",
                    "author": {
                        "email": "me@colby.fyi",
                        "name": "Colby Swandale"
                    },
                    "message": "remove lockfile_upgrade_warning feature flag",
                    "distinct": true,
                    "url": "https://api.github.com/repos/bundler/bundler/commits/c70d3aa82857bbe09b9f9ffdc5ba106bd56ecf38"
                }
            ]
        })
    }

    it 'should display correct details' do
        data = get_data.merge("payload" => payload, "type" => "PushEvent")
        activity = Activity::Push.new(data)

        expect(activity.details).to eq("Pushed 1 commits from refs/heads/colby/bundler-2-merge\n")
    end
end