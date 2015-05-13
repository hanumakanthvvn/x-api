# config valid only for current version of Capistrano
lock "3.4.0"

set :application, "exercism-api"
set :repo_url, "git@github.com:hanumakanthvvn/x-api.git"

# Default branch is :master
set :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/u/apps/exercism/x-api"

# Default value for :scm is :git
set :scm, :git
set :git_strategy, Capistrano::Git::SubmoduleStrategy

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

set :git_keep_meta, true

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
       #execute "cd '#{release_path}'; docker build -t exercism-api ."
       execute "docker stop `docker ps -a -q`"
       execute "docker rm `docker ps -a -q`"
       execute "cd '#{release_path}'; fig -p exercism-api up -d"
    end
  end

  
  desc "Recreate symlink"
  task :resymlink do
    on roles(:app), in: :sequence, wait: 5 do
      # update the submodules remote and merge
      # remove all the .git files from the new release folder
      # symlink to the new release folder to current folder
      execute "cd #{release_path} && git submodule update --remote --merge"
      execute "find #{release_path} -name '.git*' | xargs -I {} rm -rfv '{}'"
      execute "rm -f #{current_path} && ln -s #{release_path} #{current_path}"
    end
  end


# remote_file 'config/database.yml' => 'config/database.yml'
  after :updating, :resymlink
  after :publishing, :build
end
