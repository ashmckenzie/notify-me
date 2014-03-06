Stethoscope.check :sidekiq do |response|
  pid_file = File.join(ROOT_PATH, 'tmp', 'sidekiq.pid')
  pid = File.read(pid_file).chomp
  command = %Q{/bin/ps -fp #{pid} | egrep -v '\s*UID'}

  output = `#{command}`.chomp

  response[:output] = output
  response[:status] = (output.split("\n").count == 1) ? 200 : 500
end
