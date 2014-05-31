module Hiraoyogi
  class Database
    def initialize(analyzer)
      @indices = {}
      @analyzer = analyzer
    end

    def index(url, doc)
      @indices[url] = @analyzer.analyze_text(body_text(doc))
    end

    def build
      raise NotImplementedError
    end

    private

    def body_text(doc)
      doc.css("body").text.gsub(/\n|\t/, "")
    end
  end
end
