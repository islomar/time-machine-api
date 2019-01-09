class InvalidIso8601DatetimeFormatError < StandardError
    attr_reader :messages

    def initialize()
      @messages = "The date passed must have a ISO8601 format"
    end
  end