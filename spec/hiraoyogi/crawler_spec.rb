require "spec_helper"
require "webmock/rspec"

module Hiraoyogi
  describe Crawler do
    let(:crawler) do
      described_class.new(database)
    end

    let(:database) do
      double(:database, index: true, build: true)
    end

    describe "#crawl" do
      let(:expected_result) do
        [
         "http://example.com/index.html",
         "http://example.com/child1.html",
         "http://example.com/child10.html",
         "http://example.com/~user/en/index.html"
        ]
      end

      before do
        stub_request(:get, "http://example.com/index.html")
          .to_return(body: open(fixture_path("index.html")), status: 200)
        stub_request(:get, "http://example.com/child1.html")
          .to_return(body: open(fixture_path("child1.html")), status: 200)
        stub_request(:get, "http://example.com/child2.php")
          .to_return(body: open(fixture_path("child2.php.html")), status: 200)
        stub_request(:get, "http://example.com/child10.html")
          .to_return(body: open(fixture_path("child10.html")), status: 200)
        stub_request(:get, "http://example.com/grandchild2.html")
          .to_return(status: 403)
        stub_request(:get, "http://example.com/grandchild3.html")
          .to_return(status: 404)
        stub_request(:get, "http://example.com/~user/index.html")
          .to_return(status: 301, headers: { "Location" => "http://example.com/~user/en/index.html" })
        stub_request(:get, "http://example.com/~user/en/index.html")
          .to_return(body: open(fixture_path("user.html")), status: 200)
      end

      it "should call Database#indexing with static pages" do
        crawler.crawl("http://example.com")
        expect(database).to have_received(:index).exactly(expected_result.length).times
      end

      it "should call Database#build once" do
        crawler.crawl("http://example.com")
        expect(database).to have_received(:build).once
      end

      it "should collect the URL list" do
        crawler.crawl("http://example.com")
        expect(crawler.url_list).to match_array expected_result
      end
    end
  end
end
