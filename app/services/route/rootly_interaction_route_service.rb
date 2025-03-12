
class Route::RootlyInteractionRouteService
    def initialize(params, swi)
        @params = params
        @slack_workspace_id = swi
    end

    def route_and_execute
        case @params["type"]
        when "view_submission"
            handle_declare_modal_submit
        else
            return "Success!"
        end
    end


    def call
        route_and_execute
    end

    private

    def handle_declare_modal_submit
        service = Interaction::RootlyDeclareModalSubmitService.new(@params, @slack_workspace_id)
        service.call
    end

end