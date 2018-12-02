# frozen_string_literal: true

Bundler.setup(:default)
$: << File.expand_path('', __FILE__)

require_relative 'lib/app'

use Rack::Static,
    urls: ['/', '/css', '/js'], root: 'public', index: 'index.html'

run App
