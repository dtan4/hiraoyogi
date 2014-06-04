require "sinatra/base"
require "slim"

module Hiraoyogi
  class Server < Sinatra::Base
    set :root, File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "app"))

    configure :development do
      require "sinatra/reloader"
      register Sinatra::Reloader
    end

    get "/" do
      slim :index
    end
  end
end
