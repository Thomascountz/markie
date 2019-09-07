module Markie
  class Node
    attr_reader :type, :token_count, :children, :value
    def initialize(type:, token_count:, children: [], value: nil)
      @type = type
      @token_count = token_count
      @children = children
      @value = value
    end

    def to_json
      "{ \"type\": \"#{type}\", \"token_count\": \"#{token_count}\", \"value\": \"#{value}\", \"children\": [#{children.map(&:to_json).join(", ") if children.any?}] }"
    end
  end
end
