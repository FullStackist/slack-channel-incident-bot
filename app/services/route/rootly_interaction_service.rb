# fill in with 'Interaction' details
class RootlyInteractionRouteService
    def initialize(params)
        @params = params
    end

    def verify_command
        if @command_content_raw.empty?
            raise "Empty command: please provide a non-empty command"
        elsif @command_itself.empty?
            raise "Main command ommitted: please provide a main command"
        else
            return true
        end

        false
    end

    def route_and_execute
        case @params[:type]
        when "view_submission"
            handle_declare_modal_submit
        else
            return "Success!"
        end
    end


    def call
        #command_verification = verify_command

        #unless command_verification
        #    return "Command verification failed: please provide a valid command"
        #end

        route_and_execute
    end

    private

    def handle_declare_modal_submit
        service = RootlyDeclareModalSubmitService.new(@params)
        service.call
    end

end