require 'yaml'

BASE = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__

config_file = File.expand_path(File.join(BASE, '..', 'config.yml'))
c = YAML.load_file(config_file)['deploy']

God.watch do |w|
  w.name      = 'notify-me'
  w.uid       = 'deploy'

  w.dir       = c['working_directory']
  w.log       = c['log_file']

  w.start     = %Q{HOME="/home/deploy" bundle exec sidekiq -C #{c['working_directory']}/config/sidekiq.yml -r #{c['working_directory']}/config/initialise.rb}

  # Important that this appears here
  w.keepalive

  w.transition(:up, :start) do |on|
    on.condition(:process_exits) do |c|
      c.notify = 'admin'
    end
  end
end