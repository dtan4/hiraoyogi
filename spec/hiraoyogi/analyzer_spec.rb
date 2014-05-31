# -*- coding: utf-8 -*-

require "spec_helper"

module Hiraoyogi
  describe Analyzer do
    let(:analyzer) do
      described_class.new
    end

    let(:text) do
      "すもももももももものうち a"
    end

    describe "#analyze_text" do
      it "should create index table" do
        result = analyzer.analyze_text(text)
        expect(result).to include "すもも" => 1, "もも" => 2, "うち" => 1
        expect(result).not_to include "a" => 1
      end
    end
  end
end
