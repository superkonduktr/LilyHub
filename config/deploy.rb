lock '3.3.3'
set :application, 'lilyhub'
set :repo_url, 'git@github.com:superkonduktr/LilyHub.git'
set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"] || "master"
set :deploy_to, '/var/www/lilyhub'
set :scm, :git
set :format, :pretty
set :log_level, :debug
set :pty, true
set :keep_releases, 5
set :default_env, { rvm_bin_path: '/usr/local/rvm/bin' }
set :stage, 'production'

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

before :deploy, "sidekiq:stop"
after :deploy, "unicorn:stop",
               "unicorn:start",
               "sidekiq:start"
