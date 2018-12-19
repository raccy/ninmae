#!/bin/env ruby
# frozen_string_literal: true

### --- 設定 ---
# 設定のデフォルトはこのCGIファイルと同じ場所の config ディレクトリです。
# ディレクトリを変更した場合は、下記でパスを設定してください。
#APP_CONFIG_DIR = /path/to/config
### ------------

require 'yaml'
require 'json'

class Ninmae
  SETTINGS_YAML_FILE = 'settings.yml'

  def initialize(config_dir)
    @config_dir = config_dir
    @settings = YAML.load_file(File.join(@config_dir, 'settings.yml'))
  end

  def run

  end

  def run_cgi
    require 'cgi'
    cgi = CGI.new

  end

  def check_session(cookies)
    cookies["#{@settings['name']}_session_key"]
  end

  # 設定をチェックします。
  def check_settings
    result = {}
    name = @settings['name']
    if name.is_a(String) && name =~ /\A[a-z][a-z\d]+\z/
      result['name'] = {value: name, status: :ok}

  end
end





if $0 == __FILE__
  begin
    APP_CONFIG_DIR ||= File.expanded('config', __dir__)
    app = Ninmae.new(APP_CONFIG_DIR)
    if ENV['GATEWAY_INTERFACE'] == 'CGI/1.1'
      app.run_cgi
    else
      app.run
    end
  rescue => e
    if ENV['GATEWAY_INTERFACE'] == 'CGI/1.1'
      print "Content-type: application/json\n\n"
      puts({
        status: 'error',
        error: e.message,
      }.to_json)
    else
      raise
    end
  end
end
