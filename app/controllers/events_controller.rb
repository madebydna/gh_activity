class EventsController < ApplicationController
  def index
  end

  def get_timeline
    @username = params[:username].squish
    fetcher = ActivityFetcher.new(@username)
    result = fetcher.run
    if api_failure(result)
      @error = result[:error]
    else
      @activities = result.map do |data|
        data.slice!("type", "actor", "repo", "payload", "created_at")
        Activity::Base.create_activity(data)
      end
      @author = @activities.first.try(:author)
    end

    respond_to do |format|
      format.js
      format.html { render :nothing => true }
    end
  end

  private

  def api_failure(result)
    result.is_a?(Hash) && result.has_key?(:error)
  end
end
