require "mongo"

module Hiraoyogi
  module Database
    class MongoDB < Base
      include Mongo

      def initialize(analyzer)
        super
        @client = MongoClient.new
        @collection = @client["hiraoyogi"]["index-collection"]
      end

      def build
        @collection.insert(transpose_index_table)
      end
    end
  end
end
