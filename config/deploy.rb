# config valid only for current version of Capistrano
lock "3.4.0"

set :application, "exercism-api"
set :repo_url, "git@github.com:hanumakanthvvn/x-api.git"

# Default branch is :master
set :branch, "qa-branch" # proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/pramati/projects/exercism/x-api"

# Default value for :scm is :git
set :scm, :git
set :git_strategy, Capistrano::Git::SubmoduleStrategy

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
namespace :deploy do
  desc "Restart application"
  task :build do
    on roles(:app), in: :sequence, wait: 5 do
      # we dont need to add this build step on every deploy
      # only run build when something changed in Gemfile or Dockerfile
       # execute "cd '#{release_path}'; docker build -t exercism-api ."
       # execute "cd '#{release_path}'; fig -p exercism-api up -d"
    end
  end

# remote_file 'config/database.yml' => 'config/database.yml'
  after :publishing, :build
end
