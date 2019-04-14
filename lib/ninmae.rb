# frozen_string_literal: true

require 'cgi'
require 'yaml'
require 'json'
require 'digest/sha2'
require 'securerandom'
require 'time'
require 'ipaddr'

require_relative 'ninmae/error'
require_relative 'ninmae/version'

class Ninmae
  SETTINGS_YAML_FILE = 'settings.yml'

  def initialize(config_dir)
    @config_dir = config_dir
    @settings = YAML.load_file(File.join(@config_dir, SETTINGS_YAML_FILE))
  end

  def secret_session
    @settings['secret']['session']
  end

  def secret_api
    @settings['secret']['api']
  end

  def path
    @settings['path']
  end

  def check_secret
    secret_session =~ /\A[\w\-\/+=]{20,}\z/ &&
      secret_api =~ /\A[\x20-\x7E]{20,}\z/
  end

  def check_session(cookies)
    key = cookies[session_key]
    salt = cookies[session_salt]
    time = Time.at(cookies[session_time].to_i)
    return unless key && salt
    return unless create_session_key(salt, time) == key
    time
  end

  # 有効期限切れチェック
  def within_validity_period?(time, ip)
    expire = @settings['expire_time'][check_ip(ip)]
    return true if expire.nil?
    Time.now <= time + expire
  end

  # IPアドレスの信頼性チェック
  def check_ip(ip)
    if @settisgs['trusted']['ip'].any? { |net| IPAddr.new(net).include?(ip) }
      'trusted_ip'
    elsif @settisgs['suspicious']['ip']
        .any? { |net| IPAddr.new(net).include?(ip) }
      'suspicious_ip'
    else
      begin
        resolv_name = Resolv.getname(ip.to_s)
        if resolv_name.end_with?(*@settings['trusted']['domain'])
          'trusted_domain'
        elsif resolv_name.end_with?(*@settings['suspicious']['domain'])
          'suspicious_domain'
        else
          'other_domain'
        end
      rescue Resolv::ResolvError
        return 'unknown_ip'
      end
    end
  end

  def create_session_key(salt, time)
    str = salt + session_secret + time.utc.iso8601
    Digest::SHA256.hexdigest(str)
  end

  def create_auth_key(time)
    str = name + auth_secret + time.utc.iso8601
    Digest::SHA256.hexdigest(str)
  end

  def name
    @settings['name']
  end

  def session_key_name
    "#{name}_session_key"
  end

  def sennsion_info_name
    "#{name}_session_info"
  end

  def auth_key_name
    "#{name}_auth_key"
  end

  def session_secret
    @sesstings['secret']['session']
  end

  def auth_secret
    @sesstings['secret']['auth']
  end

  # 設定をチェックします。
  def check_settings
    result = {}
    name = @settings['name']
    if name.is_a(String) && name =~ /\A[a-z][\da-z]+\z/
      result['name'] = {value: name, status: :ok}
    end
  end
end
