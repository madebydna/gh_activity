module Activity
    class IssueComment < Base

        attr_accessor :comment, :issue_url, :issue_title

        # override
        def details
            @details ||= begin
                <<~HEREDOC
                #{payload["action"].capitalize} comment on issue [#{issue_title}](#{issue_url}):
                \"#{comment}\"
                HEREDOC
            end
        end

        def comment
            @comment ||= payload["comment"]["body"]
        end

        def issue_title
            @issue ||= payload["issue"]["title"]
        end

        def issue_url
            @issue_url ||= payload["issue"]["html_url"]
        end

    end
end