class GameController < ApplicationController
  def index
    @hash = SecureRandom.hex
    @num_choices = 4
  end

  def play
    id = params[:id]

    shows = $plex.library.sections.find{ |x| x.type == "show" }
    seinfeld = shows.all.find{ |x| x.title == "Seinfeld" }
    episodes = seinfeld.seasons.map{ |x| x.episodes }.flatten(1).sample(4)
    correct_episode = episodes.sample(1).first
    media = correct_episode.medias.first
    file_key = media.parts.first.key
    duration = media.duration.to_i / 1000 # seconds
    start_time = rand(0..duration)
    end_time = start_time + 5
    
    stream_url = "http://#{ENV['PLEX_HOST']}:32400#{file_key}?X-Plex-Token=#{ENV['PLEX_TOKEN']}#t=#{start_time},#{end_time}"
    correct_index = episodes.index correct_episode
    $redis.setex id, 300, {:stream_url => stream_url, :answer_index => correct_index}.to_json

    choices = episodes.map{ |x| x.title }

    render json: {
      :video_url => "#{request.base_url}/play/video?id=#{id}#t=#{start_time},#{end_time}",
      :choices => choices
    }
  end

  def video
    data = JSON.parse($redis.get params[:id])
    
    redirect_to data["stream_url"]
  end

  def validate
    data = JSON.parse($redis.get params[:id])
    result = data["answer_index"] == params[:answer].to_i

    current_user.score += result ? 1 : -1
    current_user.correct += 1 unless !result
    current_user.incorrect += 1 unless result
    current_user.save

    render json: {
      :result => result,
      :answer => data["answer_index"]
    }
  end

  def leaderboard
    users = User.order("score DESC").limit(15)

    render json: {
      :users => users
    }
  end
end
