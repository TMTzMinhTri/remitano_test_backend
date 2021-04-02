module V1::Concerns::Helpers
    extend Grape::API::Helpers
  
    def declared_params
      @declared_params ||= ActionController::Parameters.new(declared(params, include_missing: false)).permit!
    end
  
    def authenticate_user!
      error!("401 Unauthorized", 401) unless current_user
    end
  
    def current_user
      User.authorize(access_token_param)
    end
  
    private
  
    def access_token_param
      token = headers["Authorization"]
      { access_token: token }
    end
  end
  