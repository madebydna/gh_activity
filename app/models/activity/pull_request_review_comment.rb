module Activity
    class PullRequestReviewComment < Base

        def details
            @details ||= begin
                <<~HEREDOC
                Left [comment](#{comment_url}) on #{pr_state} pull request [#{pr_title}](#{pr_url})
                HEREDOC
            end
        end

        def comment_url
            @comment_url ||= payload["comment"]["html_url"]
        end

        def pr_state
            @pr_state ||= payload["pull_request"]["state"]
        end

        def pr_url
            @pr_url ||= payload["pull_request"]["html_url"]
        end

        def pr_title
            @pr_title ||= payload["pull_request"]["title"]
        end

    end
end