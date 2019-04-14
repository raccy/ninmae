# frozen_string_literal: true

$: << File.expand_path('lib', __dir__)

require 'ninmae/app'

app = Ninmae::App.new(APP_CONFIG_DIR)
Rack::Handler::CGI.run app
