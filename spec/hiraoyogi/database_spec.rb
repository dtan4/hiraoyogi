require "spec_helper"

module Hiraoyogi
  describe Database do
    let(:database) { described_class.new }

    describe "#index" do

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
