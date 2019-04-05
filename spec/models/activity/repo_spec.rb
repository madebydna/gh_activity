require 'rails_helper'

describe Activity::Repo do
    it 'can be instantiated with a hash of attributes' do
        repo = Activity::Repo.new(id: 123, name: "bundler/bundler", url: "https://api.github.com/repos/bundler/bundler")

        expect(repo.id).to eq(123)
        expect(repo.name).to eq("bundler/bundler")
        expect(repo.url).to eq("https://api.github.com/repos/bundler/bundler")
    end
end