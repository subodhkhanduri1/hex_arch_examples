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

    def current_user
      @current_user ||= (
        user_repository.find(request.current_user_id)
        user_repository = Repository.for(User)
      )
    end
  end
end
