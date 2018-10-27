# frozen_string_literal: true

require 'sinatra/base'

class App < Sinatra::Base
  get '/' do
    slim :top
  end

  run! if app_file == $0
end
