#!/bin/env ruby
# frozen_string_literal: true

### --- 設定 ---
# 設定のデフォルトはこのCGIファイルと同じ場所の config ディレクトリです。
# ディレクトリを変更した場合は、下記でパスを設定してください。
# APP_CONFIG_DIR = /path/to/config

### ------------

$: << File.expand_path('../lib', __dir__)

require 'cgi'
require 'json'

require 'ninmae'

APP_CONFIG_DIR ||= File.expand_path('../config', __dir__)
cgi = cgi.new

begin
  app = Ninmae.new(APP_CONFIG_DIR)
  app.run(cgi)
rescue StandardError => e
  cgi.out('apllication/json') do
    {
      status: 'error',
      error: e.message,
    }.to_json
  end
end
