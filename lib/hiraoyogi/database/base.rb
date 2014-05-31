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

      private

      def body_text(doc)
        doc.css("body").text.gsub(/\n|\t/, "")
      end

      def transpose_index_table
        @index_table.inject({}).each do |transposed, url, index|
          index.each do |word, count|
            transposed[word] ||= {}
            transposed[word][url] = count
          end

          transposed
        end
      end
    end
  end
end
