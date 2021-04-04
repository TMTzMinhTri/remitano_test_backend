class V1::User < Grape::API
  helpers V1::Concerns::Helpers

  namespace "user" do
    resource :register do
      params do
        requires :username, type: String
        requires :password, type: String
        requires :password_confirmation, type: String
      end
      post do
        new_user = UserService.new(declared_params).create
        extra_result = {
          access_token: new_user.authentication_token
        }
        present extra_result
        present new_user, with: Entities::User
      end
    end

    resource :sign_in do
      params do
        requires :username, type: String
        requires :password, type: String
      end
      post do
        user = User.authorize!(declared_params)
        extra_result = {
          access_token: user.authentication_token
        }
        present extra_result
        present user, with: Entities::User
      end
    end

    resource :me do
      get do
        authenticate_user!
        extra_result = {
          access_token: current_user.authentication_token
        }
        present extra_result
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
