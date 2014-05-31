require "nkf"

module Hiraoyogi
  module Database
    class Base
      def initialize(analyzer)
        @index_table = {}
        @analyzer = analyzer
      end

      def index(url, doc)
        @index_table[url] = @analyzer.analyze_text(body_text(doc))
      end

      def build
        raise NotImplementedError
      end

      protected

      def body_text(doc)
        NKF.nkf("-w", doc.css("body").text).gsub(/\n|\t/, "")
      end

      def transpose_index_table
        transposed = {}

        @index_table.each do |url, index|
          index.each do |word, count|
            transposed[word] ||= {}
            transposed[word][url] = count
          end
        end

        transposed
      end
    end
  end
end
