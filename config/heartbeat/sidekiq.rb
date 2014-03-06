Stethoscope.check :sidekiq do |response|
  pid_file = File.join(ROOT_PATH, 'tmp', 'sidekiq.pid')
  pid = File.read(pid_file).chomp
  command = %Q{/bin/ps -fp #{pid} | tail -n1}

  output = `#{command}`.chomp

  response[:output] = output
  response[:status] = output.empty? ? 500 : 200
end
