module Services
  class ResponseBase

    attr_reader :error

    def initialize(error: nil)
      self.error = error
    end

    def success?
      error.nil?
    end

    protected

    attr_writer :error

  end
end
