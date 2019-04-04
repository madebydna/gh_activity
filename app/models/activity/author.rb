module Activity
    class Author
        attr_accessor :id, :login, :display_login, :gravatar_id
        attr_accessor :url, :avatar_url

        include ActiveModel::Model

    end
end