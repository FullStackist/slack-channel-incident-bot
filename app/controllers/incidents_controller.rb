class IncidentsController < ApplicationController
  def index
    sort_key = params["sort_by"] || "title"
    sort_direction = params["direction"] || "asc"

    Rails.logger.info "from CONTROLLER logic #{params} #{params["sort_direction"]}"

    @incidents = Incident.all
    @incidents = IncidentListComponent.new(incidents: @incidents).custom_sort(sort_key, sort_direction)
  end
end
