class Entities::Movie < Entities::Base
  expose :id
  expose :youtube_id
  expose :title
  expose :description
  expose :tags
  expose :user, merge: true do |movie, _options|
    Entities::User.represent(movie.user, root: false, only: [:username])
  end
end
