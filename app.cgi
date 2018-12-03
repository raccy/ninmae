#!/bin/env ruby
# frozen_string_literal: true

require 'yaml'

DATA_DIR = File.expand('./data', __FILE__)

if $0 == __FILE__
  settings = YAML.load_file(File.join(DATA_DIR, 'ninmae.yml'))
end


print 'Content-type: text/html\n\n'

puts 'test...'

require 'sinatra/base'

Rack::Handler::CGI.new App.new
