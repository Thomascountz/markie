require "rspec"
require "node"

RSpec.describe Node do
  describe "#to_json" do
    it "returns a JSON string representation of a node" do
      node = Node.new(type: :text, token_count: 1, value: "text")
      expect(node.to_json).to eq("{ \"type\": \"text\", \"token_count\": \"1\", \"value\": \"text\", \"children\": [] }")
    end

    it "returns a JSON string representation of a node with children" do
      node = Node.new(type: :body, token_count: 1, children: [
        Node.new(type: :paragraph, token_count: 1, children: [
          Node.new(type: :text, token_count: 1, value: "text"),
        ]),
      ])

      expect(node.to_json).to eq("{ \"type\": \"body\", \"token_count\": \"1\", \"value\": \"\", \"children\": [{ \"type\": \"paragraph\", \"token_count\": \"1\", \"value\": \"\", \"children\": [{ \"type\": \"text\", \"token_count\": \"1\", \"value\": \"text\", \"children\": [] }] }] }")
    end
  end
end
