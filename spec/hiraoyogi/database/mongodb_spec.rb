require "spec_helper"

module Hiraoyogi
  module Database
    describe MongoDB do
      let(:analyzer) do
        double(Analyzer)
      end

      let(:mongodb) do
        described_class.new(analyzer)
      end

      describe "#build" do
        let(:collection) do
          double(insert: true)
        end

        let(:index_table) do
          {
           "http://example.com/page1" => { "a" => 1, "b" => 2 },
           "http://example.com/page2" => { "b" => 1, "c" => 1 }
          }
        end

        let(:transposed_index_table) do
          {
           "a" => { "http://example.com/page1" => 1 },
           "b" => { "http://example.com/page1" => 2, "http://example.com/page2" => 1 },
           "c" => { "http://example.com/page2" => 1 }
          }
        end

        before do
          mongodb.instance_variable_set(:@index_table, index_table)
          mongodb.instance_variable_set(:@collection, collection)
        end

        it "should insert index table to MongoDB" do
          expect(collection).to receive(:insert).with(transposed_index_table)
          mongodb.build
        end
      end
    end
  end
end
