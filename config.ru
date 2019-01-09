require_relative 'app'

factory = Factory.new
time_machine_service = factory.time_machine_service

run TimeMachineAPI.new(time_machine_service)
