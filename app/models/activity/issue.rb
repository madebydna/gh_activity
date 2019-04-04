module Activity
    class Issue < Base

        def details
            @details ||= begin
                <<~HEREDOC
                #{payload["action"].capitalize} [issue](#{issue_url}) #{issue_title}
                HEREDOC
            end
        end

        def issue_title
            payload["issue"]["title"]
        end

        def issue_url
            payload["issue"]["html_url"]
        end

    end
end