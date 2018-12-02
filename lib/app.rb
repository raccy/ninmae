# frozen_string_literal: true

require 'sinatra/base'
require 'json'

class App < Sinatra::Base
  get '/app' do
    content_type 'application/json'

  end



end
