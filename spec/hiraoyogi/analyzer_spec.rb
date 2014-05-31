# -*- coding: utf-8 -*-

require "spec_helper"

module Hiraoyogi
  describe Analyzer do
    let(:analyzer) do
      described_class.new
    end

    let(:text) do
      "すもももももももものうち"
    end

    describe "#analyze_text" do
      it "should create index table" do
        expect(analyzer.analyze_text(text)).to include "すもも" => 1, "もも" => 2, "うち" => 1
      end
    end
  end
end
