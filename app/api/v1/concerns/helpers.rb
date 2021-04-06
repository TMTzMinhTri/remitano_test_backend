module V1::Concerns::Helpers
  extend Grape::API::Helpers
  include Pagy::Backend

  def declared_params
    @declared_params ||= ActionController::Parameters.new(declared(params, include_missing: false)).permit!
  end

  def authenticate_user!
    error!("401 Unauthorized", 401) unless current_user
  end

  def current_user
    User.authorize(access_token_param)
  end

  def pagination_values(collection)
    pagy, data = pagy collection, {:items => 5}
    {
      data: data,
      pagination: pagy,
    }
  end

  params :pagination do
    optional :page, type: Integer, desc: "Page number!"
  end

  private

  def access_token_param
    token = headers["Authorization"]
    { access_token: token }
  end
end
