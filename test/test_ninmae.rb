# frozen_string_literal: true

require 'ninmae'

require 'minitest/autorun'
require 'stringio'


describe Ninmae do
  before do
    @ninmae = Ninmae.new(File.expand_path('config/default', __dir__))
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
end
