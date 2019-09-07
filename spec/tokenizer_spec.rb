require "rspec"
require "markie/tokenizer"

RSpec.describe Markie::Tokenizer do
  describe ".tokenize" do
    describe "tokenizing an empty string" do
      it "it returns a Markie::Token with type `:eof`" do
        markdown = ""
        expected_tokens = [Markie::Token.new(type: :eof)]

        actual_tokens = Markie::Tokenizer.tokenize(markdown)

        expect(actual_tokens.map(&:type)).to eq(expected_tokens.map(&:type))
      end
    end

    describe "tokenizing a markdown string" do
      it "returns a list of Markie::Tokens" do
        markdown = "_italics_*bold*[text](link)\n"
        expected_tokens = [Markie::Token.new(type: :underscore, value: "_"),
                           Markie::Token.new(type: :text, value: "italics"),
                           Markie::Token.new(type: :underscore, value: "_"),
                           Markie::Token.new(type: :asterisk, value: "*"),
                           Markie::Token.new(type: :text, value: "bold"),
                           Markie::Token.new(type: :asterisk, value: "*"),
                           Markie::Token.new(type: :open_square_bracket, value: "["),
                           Markie::Token.new(type: :text, value: "text"),
                           Markie::Token.new(type: :close_square_bracket, value: "]"),
                           Markie::Token.new(type: :open_parenthesis, value: "("),
                           Markie::Token.new(type: :text, value: "link"),
                           Markie::Token.new(type: :close_parenthesis, value: ")"),
                           Markie::Token.new(type: :newline, value: "\n"),
                           Markie::Token.new(type: :eof, value: ""),]

        actual_tokens = Markie::Tokenizer.tokenize(markdown)

        expect(actual_tokens.map(&:type)).to eq(expected_tokens.map(&:type))
        expect(actual_tokens.map(&:value)).to eq(expected_tokens.map(&:value))
      end
    end

    describe "tokenizing text" do
      it "it returns a Markie::Token with type `:text` and value equal to all concurrent text characters" do
        markdown = "concurrenttextcharacters"
        expected_tokens = [Markie::Token.new(type: :text, value: "concurrenttextcharacters")]

        actual_tokens = Markie::Tokenizer.tokenize(markdown)

        expect(actual_tokens[0].type).to eq(expected_tokens[0].type)
        expect(actual_tokens[0].value).to eq(expected_tokens[0].value)
      end
    end

    describe "tokenizing `_`" do
      it "it returns a Markie::Token with type `:underscore` and value `_`" do
        markdown = "_"
        expected_tokens = [Markie::Token.new(type: :underscore, value: "_")]

        actual_tokens = Markie::Tokenizer.tokenize(markdown)

        expect(actual_tokens[0].type).to eq(expected_tokens[0].type)
        expect(actual_tokens[0].value).to eq(expected_tokens[0].value)
      end
    end

    describe "tokenizing `*`" do
      it "it returns a Markie::Token with type `:asterisk` and value `*`" do
        markdown = "*"
        expected_tokens = [Markie::Token.new(type: :asterisk, value: "*")]

        actual_tokens = Markie::Tokenizer.tokenize(markdown)

        expect(actual_tokens[0].type).to eq(expected_tokens[0].type)
        expect(actual_tokens[0].value).to eq(expected_tokens[0].value)
      end
    end

    describe "tokenizing `[`" do
      it "it returns a Markie::Token with type `:open_square_bracket` and value `[`" do
        markdown = "["
        expected_tokens = [Markie::Token.new(type: :open_square_bracket, value: "[")]

        actual_tokens = Markie::Tokenizer.tokenize(markdown)

        expect(actual_tokens[0].type).to eq(expected_tokens[0].type)
        expect(actual_tokens[0].value).to eq(expected_tokens[0].value)
      end
    end

    describe "tokenizing `]`" do
      it "it returns a Markie::Token with type `:close_square_bracket` and value `]`" do
        markdown = "]"
        expected_tokens = [Markie::Token.new(type: :close_square_bracket, value: "]")]

        actual_tokens = Markie::Tokenizer.tokenize(markdown)

        expect(actual_tokens[0].type).to eq(expected_tokens[0].type)
        expect(actual_tokens[0].value).to eq(expected_tokens[0].value)
      end
    end

    describe "tokenizing `(`" do
      it "it returns a Markie::Token with type `:open_parenthesis` and value `(`" do
        markdown = "("
        expected_tokens = [Markie::Token.new(type: :open_parenthesis, value: "(")]

        actual_tokens = Markie::Tokenizer.tokenize(markdown)

        expect(actual_tokens[0].type).to eq(expected_tokens[0].type)
        expect(actual_tokens[0].value).to eq(expected_tokens[0].value)
      end
    end

    describe "tokenizing `)`" do
      it "it returns a Markie::Token with type `:close_parenthesis` and value `)`" do
        markdown = ")"
        expected_tokens = [Markie::Token.new(type: :close_parenthesis, value: ")")]

        actual_tokens = Markie::Tokenizer.tokenize(markdown)

        expect(actual_tokens[0].type).to eq(expected_tokens[0].type)
        expect(actual_tokens[0].value).to eq(expected_tokens[0].value)
      end
    end

    describe "tokenizing `\\n`" do
      it "it returns a Markie::Token with type `:newline` and value `\\n`" do
        markdown = "\n"
        expected_tokens = [Markie::Token.new(type: :newline, value: "\n")]

        actual_tokens = Markie::Tokenizer.tokenize(markdown)

        expect(actual_tokens[0].type).to eq(expected_tokens[0].type)
        expect(actual_tokens[0].value).to eq(expected_tokens[0].value)
      end
    end
  end
end
