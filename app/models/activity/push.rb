module Activity
    class Push < Base

        def details
            @details ||= begin
                <<~HEREDOC
                Pushed #{payload["distinct_size"]} commits from #{payload["ref"]}
                HEREDOC
            end
        end

    end
end