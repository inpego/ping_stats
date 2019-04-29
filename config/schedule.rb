home = '/home/ping_stats/www/current'
set :output, "#{home}/log/cron.log"
monitor_cmd = "bundle exec ruby #{home}/scripts/monitor.rb #{@environment}"

every 1.minute do
  command "cd #{home} && ~/.rvm/bin/rvm default do #{monitor_cmd}"
end
