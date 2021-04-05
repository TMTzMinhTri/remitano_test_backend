class V1::Movie < Grape::API
  helpers V1::Concerns::Helpers

  namespace "movie" do
    get do
      movies = MovieService.get_all
      present movies, with: Entities::Movie
    end

    resource :share do
      params do
        requires :link, type: String
      end
      post do
        authenticate_user!
        errors, movie = MovieService.new(current_user, declared_params).create
        if movie 
          present movie, with: Entities::Movie
        else
          error!({ error: errors, status: 422 }, 422)
        end
      end
    end
  end
end
