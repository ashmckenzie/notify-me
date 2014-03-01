# encoding: UTF-8

require File.expand_path(File.join('..', 'config', 'initialise'), __FILE__)

namespace 'notify-me' do

  desc 'Generage nginx config'
  task :generate_nginx_config do
    require 'erb'

    nginx_template_file = File.expand_path(File.join('..', 'config', 'deploy', 'notify_me.nginx.erb'), __FILE__)
    nginx_template = File.read(nginx_template_file)
    puts ERB.new(nginx_template).result(NotifyMe::Config.deploy.nginx.instance_eval { binding })
  end

  desc 'Console'
  task :console do
    require 'pry'
    require 'pry-debugger'
    require 'awesome_print'

    include NotifyMe

    pry
  end

  task :clear_jobs do
    Sidekiq.redis { |x| x.del(x.keys) unless x.keys.empty? }
  end
end
