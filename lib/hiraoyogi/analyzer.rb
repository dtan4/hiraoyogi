# -*- coding: utf-8 -*-

require "natto"

module Hiraoyogi
  class Analyzer
    DISALLOW_TYPE = %w(助詞 助動詞)

    def initialize
      @natto = Natto::MeCab.new
    end

    def analyze_text(text)
      result = {}

      @natto.parse(text) do |line|
        next if DISALLOW_TYPE.include?(type(line.feature))
        result[line.surface] ||= 0
        result[line.surface] += 1
      end

      result
    end

    private

    def type(feature)
      feature.split(",")[0]
    end
  end
end
