require 'sinatra'
require "sinatra/json"
require 'httpclient'
require 'logger'

require_relative './factory'
require_relative './errors'


class TimeMachineService

  DEFAULT_CLIENT = 'default'
  attr_accessor :client_to_clock

  def initialize()
    @client_to_clock = Hash.new
  end

  def now(client_name = DEFAULT_CLIENT)
    return client_to_clock[client_name] || DateTime.now.iso8601
  end

  def freeze_time(fake_time, client_name = DEFAULT_CLIENT)
    self.validate(fake_time)
    @client_to_clock[client_name] = fake_time
  end

  def validate(fake_time)
    begin
      Time.iso8601(fake_time)
    rescue
      raise InvalidIso8601DatetimeFormatError.new
    end
  end

end

class TimeMachineAPI < Sinatra::Base
  configure :production, :development do
    enable :logging
  end


  HEADER_CONTENT_TYPE_JSON = { "Content-Type" => "application/json" }

  attr_reader :time_machine_service

  def initialize(time_machine_service)
    super()
    @time_machine_service = time_machine_service
  end

  get '/time' do
    response = {"time" => time_machine_service.now}

    [HTTP::Status::OK, HEADER_CONTENT_TYPE_JSON, response.to_json]
  end

  get '/clock/:client_name' do
    response = {"time" => time_machine_service.now(params["client_name"])}

    [HTTP::Status::OK, HEADER_CONTENT_TYPE_JSON, response.to_json]
  end

  post '/time/:data' do
    begin
      fake_time = params[:data]
      time_machine_service.freeze_time(fake_time)
      response = {"time" => fake_time}
      [HTTP::Status::CREATED, HEADER_CONTENT_TYPE_JSON, response.to_json]
    rescue InvalidIso8601DatetimeFormatError => ex
      [HTTP::Status::BAD_REQUEST, ex.messages]
    end
  end

  post '/clock/:client_name' do
    begin
      body = JSON.parse(request.body.read)
      fake_time = body["time"]
      time_machine_service.freeze_time(fake_time, params["client_name"])
      response = {"time" => fake_time}
      [HTTP::Status::CREATED, HEADER_CONTENT_TYPE_JSON, response.to_json]
    rescue InvalidIso8601DatetimeFormatError => ex
      [HTTP::Status::BAD_REQUEST, ex.messages]
    end
  end
end