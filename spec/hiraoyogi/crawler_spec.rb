require "spec_helper"
require "webmock/rspec"

module Hiraoyogi
  describe Crawler do
    describe "#crawl" do
      let(:crawler) { described_class.new }

      before do
        stub_request(:get, "http://example.com/index.html")
          .to_return(body: open(fixture_path("index.html")), status: 200)
        stub_request(:get, "http://example.com/child1.html")
          .to_return(body: open(fixture_path("child1.html")), status: 200)
        stub_request(:get, "http://example.com/grandchild2.html")
          .to_return(status: 403)
        stub_request(:get, "http://example.com/grandchild3.html")
          .to_return(status: 404)
        stub_request(:get, "http://example.com/~user/index.html")
          .to_return(status: 301, headers: { "Location" => "http://example.com/~user/en/index.html" })
        stub_request(:get, "http://example.com/~user/en/index.html")
          .to_return(body: open(fixture_path("user.html")), status: 200)
      end

      it "should collect the URL list" do
        crawler.crawl("http://example.com")
        expect(crawler.url_list).to match_array [
                                                 "http://example.com/index.html",
                                                 "http://example.com/child1.html",
                                                 "http://example.com/~user/en/index.html"
                                                ]
      end
    end
  end
end
