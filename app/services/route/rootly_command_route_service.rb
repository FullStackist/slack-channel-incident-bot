require 'set'

class Route::RootlyCommandRouteService
    ELIGIBLE_COMMANDS = Set.new(['/rootly'])

    def initialize(command_params, swi)
        #@command_content_raw = command_text.strip
        #command_parts = @command_content_raw.split(" ")

        @params = command_params
        @command_itself = @params[:command]

        raw_text = @params[:text].strip
        command_args = raw_text.split(" ")
        @command_name = command_args[0]
        @command_params = ""
        if command_args.length > 1
            @command_params = command_args.slice(1..-1).join(" ")
        end

        @slack_workspace_id = swi
    end

    def verify_command
        #if @command_content_raw.empty?
        #    raise "Empty command: please provide a non-empty command"
        if @command_itself.empty?
            raise "Main command ommitted: please provide a main command"
        elsif !ELIGIBLE_COMMANDS.include?(@command_itself)
            raise "Invalid command: please use a valid command"
        else
            return true
        end

        false
    end

    def route_and_execute
        case @command_name
        when "declare"
            handle_rootly_declare
        when "resolve"
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
        service = Command::RootlyDeclareService.new(@params[:trigger_id], @command_params, @slack_workspace_id)
        service.call
    end

    def handle_rootly_resolve
        service = Command::RootlyResolveService.new(@params, @slack_workspace_id)
        service.call
    end
end