module Activity
    class Base
        def self.create_activity(data)
            case data["type"]
            when "PushEvent"
                Push.new(data)
            when "PullRequestEvent"
                PullRequest.new(data)
            when "PullRequestReviewCommentEvent"
                PullRequestReviewComment.new(data)
            when "IssuesEvent"
                Issue.new(data)
            when "IssueCommentEvent"
                IssueComment.new(data)
            when "CreateEvent"
                CreateEvent.new(data)
            else
                self.new(data)
            end
        end

        attr_accessor :author, :repo, :type, :created_at
        attr_accessor :details
        def initialize(data)
            @data = data
            @payload = data["payload"]
        end

        def author
            @author ||= Author.new(data["actor"])
        end

        def repo
            @repo ||= Repo.new(data["repo"])
        end

        def type
            @type ||= data["type"].sub(/Event/, '').underscore.humanize
        end

        def created_at
            @created_at ||= DateTime.parse(data["created_at"])
        end

        private
        attr_accessor :data, :payload
    end
end