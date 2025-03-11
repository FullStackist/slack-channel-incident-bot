class IncidentController < ApplicationController
  def list
    sort_key = params[:sort_key] || "title"
    sort_direction = params[:sort_direction] || "asc"

    @incidents = Incident.all
    @incidents = IncidentListComponent(@incidents).custom_sort(sort_key, sort_direction)
  end
end
