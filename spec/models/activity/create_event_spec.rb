require 'rails_helper'

describe Activity::CreateEvent do
    let(:payload) {
        {
            "ref" => "colby/fix-info-spec",
            "ref_type" => "branch",
            "master_branch" => "master",
            "description" => "Manage your Ruby application's gem dependencies",
            "pusher_type" => "user"
        }
    }

    it 'should display correct details' do
        data = get_data.merge("payload" => payload, "type" => "CreateEvent")
        activity = Activity::CreateEvent.new(data)

        expect(activity.details).to eq("Created branch colby/fix-info-spec\n")
    end
end