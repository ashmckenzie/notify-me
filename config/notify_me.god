require 'yaml'

BASE = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__

config_file = File.expand_path(File.join(BASE, '..', 'config.yml'))
c = YAML.load_file(config_file)['deploy']

God.watch do |w|
  w.name      = 'notify-me-sidekiq'
  w.uid       = 'deploy'

  w.dir       = c['working_directory']
  w.log       = c['log_file']

  w.start     = %Q{HOME="/home/deploy" bundle exec sidekiq -C #{c['working_directory']}/config/sidekiq.yml -P #{c['working_directory']}/tmp/sidekiq.pid -r #{c['working_directory']}/config/initialise.rb}
  w.stop      = %Q{HOME="/home/deploy" bundle exec sidekiqctl stop #{c['working_directory']}/tmp/sidekiq.pid 30}

  # Important that this appears here
  w.keepalive

  w.transition(:up, :start) do |on|
    on.condition(:process_exits) do |c|
      c.notify = 'admin'
    end
  end
end

God.watch do |w|
  w.name      = 'notify-me-irc'
  w.uid       = 'deploy'

  w.dir       = c['working_directory']
  w.log       = c['log_file']

  w.start     = %Q{HOME="/home/deploy" bundle exec rake notify-me:start_irc_daemon}

  # Important that this appears here
  w.keepalive

  w.transition(:up, :start) do |on|
    on.condition(:process_exits) do |c|
      c.notify = 'admin'
    end
  end
end
