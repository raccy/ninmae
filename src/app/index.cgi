#!/bin/env ruby
# frozen_string_literal: true

require 'bundle/setup'
Bundler.setup
$: << File.expand_path('', __FILE__)

print 'Content-type: text/html\n\n'

puts 'test...'

require 'sinatra/base'

Rack::Handler::CGI.new App.new
