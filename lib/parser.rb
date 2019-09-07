# frozen_string_literal: true

require_relative "./token"
require_relative "./node"

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
      if tokens[0].type == :eof
        return Node.new(type: :paragraph, token_count: children.map(&:token_count).sum, children: children)
      end

      if tokens[0].type == :text
        next_child = Node.new(type: :text, token_count: 1, value: tokens[0].value)

      elsif tokens[0].type == :underscore && tokens[1].type == :text && tokens[2].type == :underscore
        next_child = Node.new(type: :emphasis, token_count: 3, value: tokens[1].value)

      elsif tokens[0].type == :asterisk && tokens[1].type == :text && tokens[2].type == :asterisk
        next_child = Node.new(type: :emphasis, token_count: 3, value: tokens[1].value)

      elsif tokens[0].type == :open_square_bracket && tokens[1].type == :text && tokens[2].type == :close_square_bracket && tokens[3].type == :open_parenthesis && tokens[4].type == :text && tokens[5].type == :close_parenthesis
        next_child = Node.new(type: :link, token_count: 6, value: tokens[4].value, children: [Node.new(type: :text, token_count: 1, value: tokens[1].value)])

      end

      children.append(next_child)
      next_tokens = tokens[next_child.token_count..-1]

      parse_paragraph(next_tokens, children)
    end
  end
end
