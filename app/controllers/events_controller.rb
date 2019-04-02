class EventsController < ApplicationController
  def index
  end

  def get_timeline
    @activities = [{type: "Pull Request"}, {type: "Issue Comment"}]
    respond_to do |format|
      format.js
      format.html { render :nothing => true }
    end
  end
end
