class Factory
    def time_machine_service
        @time_machine_service ||= TimeMachineService.new()
    end
end
