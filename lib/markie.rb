require "markie/generator"
require "markie/node"
require "markie/parser"
require "markie/rule"
require "markie/token"
require "markie/tokenizer"
require "markie/version"

module Markie
  class << self
    def to_html(markdown)
      Generator.generate(
        Parser.parse(
          Tokenizer.tokenize(markdown)
        )
      )
    end
  end
end
