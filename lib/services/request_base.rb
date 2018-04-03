module Services
  class RequestBase

    attr_reader :current_user_id

    def initialize(current_user_id:)
      self.current_user_id = current_user_id
    end

    protected

    attr_writer :current_user_id
  end
end
