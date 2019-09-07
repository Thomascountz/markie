require_relative "./token"
require_relative "./rule"

class Tokenizer
  class << self
    def tokenize(markdown)
      scan(markdown, [])
    end

    private

    def scan(markdown, tokens)
      if markdown.length == 0
        return tokens.append(eof_token)
      end

      next_token = nil

      rules.each do |rule|
        if rule.applies_to?(markdown[0])
          next_token = rule.tokenize(markdown)
          break
        end
      end

      if next_token.nil?
        next_token = text_token(markdown)
      end

      scan(markdown[next_token.length..-1], tokens.append(next_token))
    end

    def eof_token
      Token.new(type: :eof, value: "")
    end

    def text_token(markdown)
      text = markdown.each_char.take_while { |char|
        !char.match?(Regexp.union(rules.map(&:regex)))
      }.join("")

      Token.new(type: :text, value: text)
    end

    def rules
      [
        Rule.new(
          regex: Regexp.new("\_"),
          tokenize_rule: ->(markdown, regex) {
            Token.new(type: :underscore, value: "_")
          }
        ),
        Rule.new(
          regex: Regexp.new("\\*"),
          tokenize_rule: ->(markdown, regex) {
            Token.new(type: :asterisk, value: "*")
          }
        ),
        Rule.new(
          regex: Regexp.new("\\["),
          tokenize_rule: ->(markdown, regex) {
            Token.new(type: :open_square_bracket, value: "[")
          }
        ),
        Rule.new(
          regex: Regexp.new("\\]"),
          tokenize_rule: ->(markdown, regex) {
            Token.new(type: :close_square_bracket, value: "]")
          }
        ),
        Rule.new(
          regex: Regexp.new("\\("),
          tokenize_rule: ->(markdown, regex) {
            Token.new(type: :open_parenthesis, value: "(")
          }
        ),
        Rule.new(
          regex: Regexp.new("\\)"),
          tokenize_rule: ->(markdown, regex) {
            Token.new(type: :close_parenthesis, value: ")")
          }
        ),
        Rule.new(
          regex: Regexp.new("\n"),
          tokenize_rule: ->(markdown, regex) {
            Token.new(type: :newline, value: "\n")
          }
        ),
      ]
    end
  end
end
