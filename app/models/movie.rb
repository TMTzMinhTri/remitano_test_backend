# == Schema Information
#
# Table name: movies
#
#  id         :bigint           not null, primary key
#  link       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_movies_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Movie < ApplicationRecord
  belongs_to :user
  validates :link, presence: true


  def title
    video[:title]
  end

  def description
    video[:description]
  end

  def tags
    video[:tags]
  end

  def youtube_id
    video[:id]
  end

  private

  def video
    @video ||= YoutubeService.new(link).get_video
  end
end
