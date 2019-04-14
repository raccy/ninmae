#!/bin/env ruby
# frozen_string_literal: true

### --- 設定 ---
# 設定のデフォルトはこのCGIファイルと同じ場所の config ディレクトリです。
# ディレクトリを変更した場合は、下記でパスを設定してください。
# APP_CONFIG_DIR = /path/to/config
### ------------

$: << File.expand_path('../lib', __dir__)
APP_CONFIG_DIR ||= File.expand_path('../config', __dir__)

require 'rack'
require 'ninmae/app'

if $0 == FILE
  app = Ninmae::App.new(APP_CONFIG_DIR)
  Rack::Handler::FCGI.run app
end
