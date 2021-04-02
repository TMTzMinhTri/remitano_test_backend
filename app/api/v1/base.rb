class V1::Base < Grape::API
    include V1::Concerns::ExceptionsHandler
    prefix "api"
    format :json
    version "v1"
  
    mount V1::User
  end
  