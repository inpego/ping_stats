threads 4, 4

if ENV['RACK_ENV'] == 'production'
  app_dir = File.expand_path('../..', __FILE__)
  shared_dir = "#{app_dir}/shared"

  directory "#{app_dir}/current"
  rackup "#{app_dir}/current/config.ru"

  pidfile "#{shared_dir}/tmp/pids/puma.pid"
  state_path "#{shared_dir}/tmp/pids/puma.state"

  bind "unix://#{shared_dir}/tmp/sockets/puma.sock"

  stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true
end
