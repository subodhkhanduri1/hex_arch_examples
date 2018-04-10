module Services
  module SessionableService

    protected

    def current_user
      @current_user ||= (
        user_repository = Persistence::Repository.for(Entities::User)
        user_repository.find(request.current_user_id)
      )
    end

  end
end
