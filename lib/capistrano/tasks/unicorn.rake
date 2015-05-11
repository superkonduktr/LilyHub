namespace :unicorn do

  desc "Stop Unicorn"
  task :stop do
    on roles(:all) do
      info "Stopping Unicorn on #{host}..."
      execute "sudo service unicorn_#{fetch(:application)} stop"
    end
  end

  desc "Start Unicorn"
  task :start do
    on roles(:all) do
      info "Starting Unicorn on #{host}..."
      execute "mkdir -p #{fetch(:deploy_to)}/current/tmp/pids"
      execute "cd #{fetch(:deploy_to)}/current && ( /usr/local/rvm/bin/rvm default do bundle exec unicorn -D -c config/unicorn.rb -E production )"
    end
  end

  desc "Restart Unicorn"
  task :restart do
    on roles(:all) do
      info "Restaring Unicorn on #{host}..."
      execute "sudo service unicorn_#{fetch(:application)} restart"
    end
  end

end
