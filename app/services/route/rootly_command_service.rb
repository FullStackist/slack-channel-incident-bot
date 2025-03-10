
class RootlyCommandRouteService
    def initialize(command_params)
        #@command_content_raw = command_text.strip
        #command_parts = @command_content_raw.split(" ")

        @params = command_params
        @command_itself = @params[:command]

        #@command_args = []
        #if command_parts.length > 1
        #    @command_args = command_parts.slice(1..-1)
        end

    end

    def verify_command
        #if @command_content_raw.empty?
        #    raise "Empty command: please provide a non-empty command"
        if @command_itself.empty?
            raise "Main command ommitted: please provide a main command"
        else
            return true
        end

        false
    end

    def route_and_execute
        case @command_itself
        when "/declare"
            handle_rootly_declare
        when "/resolve"
            handle_rootly_resolve
        else
            return "Command not found: please provide a known command (e.g. 'declare <title>' or 'resolve')"
        end
    end


    def call
        command_verification = verify_command

        unless command_verification
            return "Command verification failed: please provide a valid command"
        end

        route_and_execute
    end

    private

    def handle_rootly_declare
        service = RootlyDeclareService.new(@params[:trigger_id], @params[:text])
        service.call
    end

    def handle_rootly_resolve
        service = RootlyResolveService.new(@params)
        service.call
    end
end