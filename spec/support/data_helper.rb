module DataHelper
    def get_data
        {
            "type" => "PullRequestReviewCommentEvent",
            "payload" => {},
            "repo" => {
                "id" => 488514,
                "name" => "bundler/bundler",
                "url" => "https://api.github.com/repos/bundler/bundler"
            },
            "actor" => {
                "id" => 996377,
                "login" => "colby-swandale",
                "display_login" => "colby-swandale",
                "gravatar_id" => "",
                "url" => "https://api.github.com/users/colby-swandale",
                "avatar_url" => "https://avatars.githubusercontent.com/u/996377?"
            },
            "created_at" => "2019-04-03T05:01:42Z"
        }
    end
end

RSpec.configure do |config|
    config.include DataHelper
end
