class V1::User < Grape::API
  helpers V1::Concerns::Helpers

  namespace "user" do
    resource :register do
      params do
        optional :username, type: String
        requires :password, type: String
        requires :password_confirmation, type: String
      end
      post do
        new_user = UserService.new(declared_params).create
        present new_user, with: Entities::User
      end
    end

    resource :me do
      get do
        authenticate_user!
        present current_user, with: Entities::User
      end
    end
    
    resource :sign_out do
      delete do
        authenticate_user!
        UserService.sign_out(current_user)
        extra_result = {
          message: "Sign out success",
        }
        present extra_result
      end
    end
  end
end
