require "spec_helper"
require "nokogiri"

module Hiraoyogi
  describe Database do
    let(:analyzer) do
      double(analyze_text: {"a" => 1, "b" => 2})
    end

    let(:database) do
      described_class.new(analyzer)
    end

    let(:doc) do
      Nokogiri::HTML.parse(<<-EOS)
<html>
<head>
  <meta charset="utf-8" />
  <title>title</title>
</head>
<body>
  <p>a</p>
  <a href="hoge.html">b</a>

  b

</body>
</html>
                           EOS
    end

    let(:url) do
      "http://example.com/"
    end

    describe "#index" do
      it "should create index table" do
        expect(analyzer).to receive(:analyze_text)
        database.index(url, doc)
      end
    end

    describe "#build" do
      it "should raise NotImplementedError" do
        expect do
          database.build
        end.to raise_error NotImplementedError
      end
    end
  end
end
