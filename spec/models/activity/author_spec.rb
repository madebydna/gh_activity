require 'rails_helper'

describe Activity::Author do
    it 'can be instantiated with a hash of attributes' do
        author = Activity::Author.new({
            "id": 996377,
            "login": "colby-swandale",
            "display_login": "colby-swandale",
            "gravatar_id": "",
            "url": "https://api.github.com/users/colby-swandale",
            "avatar_url": "https://avatars.githubusercontent.com/u/996377?"
        })

        expect(author.id).to eq(996377)
        expect(author.login).to eq("colby-swandale")
        expect(author.display_login).to eq("colby-swandale")
        expect(author.gravatar_id).to be_empty
        expect(author.url).to eq("https://api.github.com/users/colby-swandale")
        expect(author.avatar_url).to eq("https://avatars.githubusercontent.com/u/996377?")
    end
end