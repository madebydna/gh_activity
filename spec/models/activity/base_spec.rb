require 'rails_helper'

describe Activity::Base do
    describe '.create_activity' do
        it 'instantiates correct type of activity' do
            data = get_data.merge("type" => "PushEvent")
            expect(Activity::Base.create_activity(data)).to be_a(Activity::Push)

            data = get_data.merge("type" => "PullRequestEvent")
            expect(Activity::Base.create_activity(data)).to be_a(Activity::PullRequest)

            data = get_data.merge("type" => "PullRequestReviewCommentEvent")
            expect(Activity::Base.create_activity(data)).to be_a(Activity::PullRequestReviewComment)

            data = get_data.merge("type" => "IssuesEvent")
            expect(Activity::Base.create_activity(data)).to be_a(Activity::Issue)

            data = get_data.merge("type" => "CreateEvent")
            expect(Activity::Base.create_activity(data)).to be_a(Activity::CreateEvent)

            # this type does not have a subclass yet
            data = get_data.merge("type" => "DeploymentStatusEvent")
            expect(Activity::Base.create_activity(data)).to be_a(Activity::Base)
        end
    end

    let (:activity) do
        data = get_data.merge("type" => "DeploymentStatusEvent")
        Activity::Base.create_activity(data)
    end

    it 'has correct type description' do
        expect(activity.type).to eq("Deployment status")
    end

    it 'parses created_at into a DateTime field' do
        expect(activity.created_at).to be_a(DateTime)
    end

    it 'has an author' do
        expect(activity.author).to be_a(Activity::Author)
        expect(activity.author.login).to eq("colby-swandale")
    end

    it 'has a repo' do
        expect(activity.repo).to be_a(Activity::Repo)
        expect(activity.repo.name).to eq("bundler/bundler")
    end

    it 'responds to #details' do
        expect(activity).to respond_to(:details)
    end
end