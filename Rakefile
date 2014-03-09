# encoding: UTF-8

require 'dcell'
require File.expand_path(File.join('..', 'config', 'initialise'), __FILE__)

namespace 'notify-me' do

  desc 'Start IRC daemon'
  task :start_irc_daemon do
    DCell.start id: 'irc_daemon', addr: "tcp://127.0.0.1:#{NotifyMe::RandomPort.new.next_available}"
    NotifyMe::Daemons::Irc.supervise_as :irc_daemon
    DCell::Node['irc_daemon'][:irc_daemon].connect_async!
    sleep
  end

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

    DCell.start id: 'console', addr: "tcp://127.0.0.1:#{NotifyMe::RandomPort.new.next_available}"

    pry
  end

  task :clear_jobs do
    Sidekiq.redis { |x| x.del(x.keys) unless x.keys.empty? }
  end
end

