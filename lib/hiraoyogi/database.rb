#!/usr/bin/env ruby

module Hiraoyogi
  class Database
    def initialize
      @indexes = {}
    end

    def index

    end

    def build
      raise NotImplementedError
    end
  end
end
