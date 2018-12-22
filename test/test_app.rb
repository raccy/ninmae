# frozen_string_literal: true

require 'minitest/autorun'
require './app.rb'

describe Ninmae do
  before do
    @ninmae = Ninmae.new
  end

  describe '通常実行' do
    it '実行' do
      @ninmae.run
    end
  end
end
