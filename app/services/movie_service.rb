class MovieService
  def initialize(current_user, params)
    @link = params[:link]
    @current_user = current_user
  end

  def create
    movie = @current_user.movies.new(link: @link)
    if movie.save
      [nil, movie]
    else
      [movie.errors.full_messages.join(", "), nil]
    end
  end

  class << self
    def get_all
      Movie.includes(:user)
    end
  end
end
