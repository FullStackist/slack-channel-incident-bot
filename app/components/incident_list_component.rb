
class IncidentListComponent << ViewComponent::Base
    def initialize(incidents:)
        @incidents = incidents
    end

    def custom_sort(sort_key, sort_direction)
        case sort_key
        when 'title'
            sort_direction == 'asc' ? @incidents.order(title: :asc) : @incidents.order(title: :desc)
        when 'creator'
            sort_direction == 'asc' ? @incidents.order(creator: :asc) : @incidents.order(creator: :desc)
        else
            sort_direction == 'asc' ? @incidents.order(created_at: :asc) : @incidents.order(created_at: :desc)
        end
    end
end