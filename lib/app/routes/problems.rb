module Xapi
  module Routes
    class Problems < Core
      get '/problems/demo' do
        pg :problems, locals: { problems: Xapi::Demo.problems }
      end

      get '/problems/:track' do |id|
        track = Xapi::Config.find(id)
        pg :problems, locals: { problems: track.problems }
      end

      get '/problems/:track/:slug' do |id, slug|
        problem = Xapi::Config.find(id).find(slug)
        problem.validate or halt 404, { error: problem.error }.to_json
        pg :problem, locals: { problem: problem }
      end

      get '/problems/remote/update/all' do
        exec = system("cd /home/ubuntu/x-api && cap staging deploy:updating")
        exec ? "Assingments updated successfully" : halt 404
      end
    end
  end
end
