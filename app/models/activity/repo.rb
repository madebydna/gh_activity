module Activity
    class Repo
        attr_accessor :id, :name, :url
        include ActiveModel::Model

    end
end