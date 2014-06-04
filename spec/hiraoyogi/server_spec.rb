require "spec_helper"
require "rack/test"

module Hiraoyogi
  describe Server do
    include Rack::Test::Methods

    let(:app) do
      described_class
    end

    describe "GET /" do
      it "should show top page" do
        get "/"
        expect(last_response).to be_ok
      end
    end
  end
end
