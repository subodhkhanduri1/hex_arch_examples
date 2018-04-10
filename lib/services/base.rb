module Services
  class Base

    def initialize(request)
      self.request = request
    end

    def execute!
      raise NotImplementedError
    end

    protected

    attr_accessor :request

  end
end
