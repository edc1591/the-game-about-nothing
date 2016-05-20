Plex.configure do |config|
  config.auth_token = ENV['PLEX_TOKEN']
end

$plex = Plex::Server.new(ENV['PLEX_HOST'], 32400)