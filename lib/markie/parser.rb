require_relative "token"
require_relative "node"

module Markie
  class Parser
    class << self
      def parse(tokens)
        parse_body(tokens)
      end

      def parse_body(tokens)
        children = [parse_paragraph(tokens)]
        Node.new(type: :body, token_count: children.map(&:token_count).sum, children: children)
      end

      def parse_paragraph(tokens, children = [])
        next_child = nil

        paragraph = grammar[:paragraph].call(tokens, children)
        return paragraph if paragraph

        grammar.values_at(:text, :emphasis, :link).each do |grammar|
          next_child = grammar.call(tokens, children)
          break if next_child
        end

        children.append(next_child)
        next_tokens = tokens[next_child.token_count..-1]

        parse_paragraph(next_tokens, children)
      end

      def grammar
        {
          paragraph: ->(tokens, children) {
            if tokens[0].type == :eof
              Node.new(type: :paragraph, token_count: children.map(&:token_count).sum, children: children)
            end
          },
          text: ->(tokens, children) {
            if tokens[0].type == :text
              Node.new(type: :text, token_count: 1, value: tokens[0].value)
            end
          },
          emphasis: ->(tokens, children) {
            if
              tokens[0].type == :underscore && tokens[1].type == :text && tokens[2].type == :underscore ||
                  tokens[0].type == :asterisk && tokens[1].type == :text && tokens[2].type == :asterisk
              Node.new(type: :emphasis, token_count: 3, value: tokens[1].value)
            end
          },
          link: ->(tokens, children) {
            if tokens[0].type == :open_square_bracket && tokens[1].type == :text && tokens[2].type == :close_square_bracket && tokens[3].type == :open_parenthesis && tokens[4].type == :text && tokens[5].type == :close_parenthesis
              Node.new(type: :link, token_count: 6, value: tokens[4].value, children: [
                grammar[:text].call(tokens[1..-1], children)
              ])
            end
          },
        }
      end
    end
  end
end
