cinch: bundle exec rake notify-me:start_irc_daemon
web: sleep 1 ; mkdir -p tmp/pids > /dev/null 2>&1 ; bundle exec puma --port 6789
sidekiq: sleep 1 ; bundle exec sidekiq -P ./tmp/sidekiq.pid -C ./config/sidekiq.yml -r ./config/initialise.rb
