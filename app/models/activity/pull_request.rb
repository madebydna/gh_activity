module Activity
    class PullRequest < Base

        attr_accessor :title, :url

        def details
            @details ||= begin
                <<~HEREDOC
                #{payload["action"].capitalize} pull request [#{title}](#{url})
                HEREDOC
            end
        end

        def title
            @title ||= payload["pull_request"]["title"]
        end

        def url
            @url ||= payload["pull_request"]["html_url"]
        end

    end
end