# frozen_string_literal: true

require 'ninmae'

require 'minitest/autorun'
require 'stringio'

def dummy_cgi_env(input = '', **opts)
  io_input = StringIO.new(-input)
  io_output = StringIO.new
  io_error = StringIO.new
  orginal_std_env = $stdin, $stdout, $stderr, $CGI_ENV
  $stdin, $stdout, $stderr = io_input, io_output, io_error
  yield
  $stdin, $stdout, $stderr, $CGI_ENV = orginal_std_env
  return io_output.string, io_output.string
end

describe Ninmae do
  before do
    @ninmae = Ninmae.new(File.expand_path('config/default', __dir__))
    @dummy_env = {
      'AUTH_TYPE' => '',
      'CONTENT_LENGTH' => '',
      'CONTENT_TYPE' => '',
      'GATEWAY_INTERFACE' => 'CGI/1.1',
      'PATH_INFO' => '',
      'PATH_TRANSLATED' => '',
      'QUERY_STRING' => '',
      'REMOTE_ADDR' => '127.0.0.1',
      'REMOTE_HOST' => 'localhost',
      'REMOTE_IDENT' => '',
      'REMOTE_USER' => '',
      'REQUEST_METHOD' => 'GET',
      'SCRIPT_NAME' => '',
      'SERVER_NAME' => 'localhost',
      'SERVER_PORT' => '80',
      'SERVER_PROTOCOL' => '',
      'SERVER_SOFTWARE' => '',
      'HTTP_ACCEPT' => 'text/html,application/xhtml+xml,appl
ication/xml;q=0.9,image/webp,image/a
png,*/*;q=0.8',
      'HTTP_ACCEPT_CHARSET' => '',
      'HTTP_ACCEPT_ENCODING' => 'gzip, deflate',
      'HTTP_ACCEPT_LANGUAGE' => 'ja,en-US;q=0.9,en;q=0.8',
      'HTTP_CACHE_CONTROL' => '',
      'HTTP_FROM' => '',
      'HTTP_HOST' => '',
      'HTTP_NEGOTIATE' => '',
      'HTTP_PRAGMA' => '',
      'HTTP_REFERER' => '',
      'HTTP_USER_AGENT' => '',
    }
  end

  describe 'コマンドライン実行' do
    it '引数無し' do
      strio = StringIO.new
      $stdout.stub :write, strio.method(:write) do
        @ninmae.run_cmd(%w[])
      end
      strio.string.must_equal <<~'RESULT'
        ninmae ver. 1.0
        name: ninmae
        path: /ninmae
        secret status: ok
        number of problems: 2
      RESULT
    end

    it 'htaccess表示' do
      strio = StringIO.new
      $stdout.stub :write, strio.method(:write) do
        @ninmae.run_cmd(%w[htaccess])
      end
      strio.string.must_equal <<~'RESULT'
        # ninmae
        ErrorDocument 403 /ninmae/api?action=redirect
        Require expr HTTP_COOKIE =~ /ninmae_session=(\d+):([\da-f]+);/ && \
          $1 -ge %{TIME} && \
          $2 == md5('ninmae$1abcdefghijklmnopqrstuvwxzy')
      RESULT
    end
  end

  describe 'CGI実行' do
    it 'redirect' do
      orginal_std_env = $stdin, $stderr, $stdout, $CGI_ENV
      $stdin = StringIO.new(-'')
      $CGI_ENV = [
        'AUTH_TYPE' => '',
        'CONTENT_LENGTH' => '',
        'CONTENT_TYPE' => '',
        'GATEWAY_INTERFACE' => '',
        'PATH_INFO' => '',
        'PATH_TRANSLATED' => '',
        'QUERY_STRING' => '',
        'REMOTE_ADDR' => '',
        'REMOTE_HOST' => '',
        'REMOTE_IDENT' => '',
        'REMOTE_USER' => '',
        'REQUEST_METHOD' => '',
        'SCRIPT_NAME' => '',
        'SERVER_NAME' => '',
        'SERVER_PORT' => '',
        'SERVER_PROTOCOL' => '',
        'SERVER_SOFTWARE' => '',
        'HTTP_ACCEPT' => '',
        'HTTP_ACCEPT_CHARSET' => '',
        'HTTP_ACCEPT_ENCODING' => '',
        'HTTP_ACCEPT_LANGUAGE' => '',
        'HTTP_CACHE_CONTROL' => '',
        'HTTP_FROM' => '',
        'HTTP_HOST' => '',
        'HTTP_NEGOTIATE' => '',
        'HTTP_PRAGMA' => '',
        'HTTP_REFERER' => '',
        'HTTP_USER_AGENT' => '',
      ]
      $stderr, $stdout = StringIO.new, StringIO.new


      cgi_mock = Minitest::Mock.new
      cgi_mock.expect(:[], 'redirect', ['action'])
      cgi_mock.expect(:request_method, 'GET')
      cgi_mock.expect(:out_options, [{
        'status' => '',
        'Location' => '/ninmae',
      }])
      cgi_mock.expect(:out_block, [<<~'RESULT'
        <!doctype html>
        <html>
        <head>
        </head>
        <body>
        </body>
        </html>
      RESULT
      ])
      def cgi_mock.out(opitons)
        out_opitons(options)
        out_block(yield)
      end
      @ninmae.run_cgi(cgi_mock)
      cgi_mock.verify

      $stdin, $stderr, $stdout, $CGI_ENV = orginal_std_env
    end

    it 'start' do
    end

    it 'answer' do
    end
end
