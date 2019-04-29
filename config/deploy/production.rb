server 'ec2-34-201-41-199.compute-1.amazonaws.com', user: 'ping_stats', roles: %w[app db web], ssh_options: {
  forward_agent: true,
  auth_methods: %w[publickey]
}
set :deploy_to, '/home/ping_stats/www'
set :rack_env, 'production'
set :puma_env, 'production'
set :puma_restart_command, '/usr/bin/env bundle exec puma'
set :bundle_without, 'development test'

namespace :sequel do
  desc 'Notify slack start of deployment'
  task :migrate do
    on roles(:app) do
      c = YAML.load(capture("cat #{shared_path}/config/database.yml"))[fetch(:rack_env)]
      database_url = "#{c['adapter']}://#{c['user']}:#{c['password']}@#{c['host']}/#{c['database']}"
      within release_path do
        execute :bundle, :exec, "sequel -m migrations #{database_url}"
      end
    end
  end
end

before 'deploy:publishing', 'sequel:migrate'
