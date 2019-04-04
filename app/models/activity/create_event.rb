module Activity
    class CreateEvent < Base

        def details
            @details ||= begin
                <<~HEREDOC
                Created #{payload["ref_type"]} #{payload["ref"]}
                HEREDOC
            end
        end

    end
end