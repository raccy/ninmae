# frozen_string_literal: true

require 'rack/base'

class App < Sinatra::Base
  get '/' do
    slim :top
  end

  get '/js'
end
