require "rspec"
require "tokenizer"

RSpec.describe Tokenizer do
  describe ".tokenize" do
    describe "tokenizing an empty string" do
      it "it returns a Token with type `:eof`" do
        markdown = ""
        expected_tokens = [Token.new(type: :eof)]

        actual_tokens = Tokenizer.tokenize(markdown)

        expect(actual_tokens.map(&:type)).to eq(expected_tokens.map(&:type))
      end
    end

    describe "tokenizing a markdown string" do
      it "returns a list of Tokens" do
        markdown = "_italics_*bold*[text](link)\n"
        expected_tokens = [Token.new(type: :underscore, value: "_"),
                           Token.new(type: :text, value: "italics"),
                           Token.new(type: :underscore, value: "_"),
                           Token.new(type: :asterisk, value: "*"),
                           Token.new(type: :text, value: "bold"),
                           Token.new(type: :asterisk, value: "*"),
                           Token.new(type: :open_square_bracket, value: "["),
                           Token.new(type: :text, value: "text"),
                           Token.new(type: :close_square_bracket, value: "]"),
                           Token.new(type: :open_parenthesis, value: "("),
                           Token.new(type: :text, value: "link"),
                           Token.new(type: :close_parenthesis, value: ")"),
                           Token.new(type: :newline, value: "\n"),
                           Token.new(type: :eof, value: ""),]

        actual_tokens = Tokenizer.tokenize(markdown)

        expect(actual_tokens.map(&:type)).to eq(expected_tokens.map(&:type))
        expect(actual_tokens.map(&:value)).to eq(expected_tokens.map(&:value))
      end
    end

    describe "tokenizing text" do
      it "it returns a Token with type `:text` and value equal to all concurrent text characters" do
        markdown = "concurrenttextcharacters"
        expected_tokens = [Token.new(type: :text, value: "concurrenttextcharacters")]

        actual_tokens = Tokenizer.tokenize(markdown)

        expect(actual_tokens[0].type).to eq(expected_tokens[0].type)
        expect(actual_tokens[0].value).to eq(expected_tokens[0].value)
      end
    end

    describe "tokenizing `_`" do
      it "it returns a Token with type `:underscore` and value `_`" do
        markdown = "_"
        expected_tokens = [Token.new(type: :underscore, value: "_")]

        actual_tokens = Tokenizer.tokenize(markdown)

        expect(actual_tokens[0].type).to eq(expected_tokens[0].type)
        expect(actual_tokens[0].value).to eq(expected_tokens[0].value)
      end
    end

    describe "tokenizing `*`" do
      it "it returns a Token with type `:asterisk` and value `*`" do
        markdown = "*"
        expected_tokens = [Token.new(type: :asterisk, value: "*")]

        actual_tokens = Tokenizer.tokenize(markdown)

        expect(actual_tokens[0].type).to eq(expected_tokens[0].type)
        expect(actual_tokens[0].value).to eq(expected_tokens[0].value)
      end
    end

    describe "tokenizing `[`" do
      it "it returns a Token with type `:open_square_bracket` and value `[`" do
        markdown = "["
        expected_tokens = [Token.new(type: :open_square_bracket, value: "[")]

        actual_tokens = Tokenizer.tokenize(markdown)

        expect(actual_tokens[0].type).to eq(expected_tokens[0].type)
        expect(actual_tokens[0].value).to eq(expected_tokens[0].value)
      end
    end

    describe "tokenizing `]`" do
      it "it returns a Token with type `:close_square_bracket` and value `]`" do
        markdown = "]"
        expected_tokens = [Token.new(type: :close_square_bracket, value: "]")]

        actual_tokens = Tokenizer.tokenize(markdown)

        expect(actual_tokens[0].type).to eq(expected_tokens[0].type)
        expect(actual_tokens[0].value).to eq(expected_tokens[0].value)
      end
    end

    describe "tokenizing `(`" do
      it "it returns a Token with type `:open_parenthesis` and value `(`" do
        markdown = "("
        expected_tokens = [Token.new(type: :open_parenthesis, value: "(")]

        actual_tokens = Tokenizer.tokenize(markdown)

        expect(actual_tokens[0].type).to eq(expected_tokens[0].type)
        expect(actual_tokens[0].value).to eq(expected_tokens[0].value)
      end
    end

    describe "tokenizing `)`" do
      it "it returns a Token with type `:close_parenthesis` and value `)`" do
        markdown = ")"
        expected_tokens = [Token.new(type: :close_parenthesis, value: ")")]

        actual_tokens = Tokenizer.tokenize(markdown)

        expect(actual_tokens[0].type).to eq(expected_tokens[0].type)
        expect(actual_tokens[0].value).to eq(expected_tokens[0].value)
      end
    end

    describe "tokenizing `\\n`" do
      it "it returns a Token with type `:newline` and value `\\n`" do
        markdown = "\n"
        expected_tokens = [Token.new(type: :newline, value: "\n")]

        actual_tokens = Tokenizer.tokenize(markdown)

        expect(actual_tokens[0].type).to eq(expected_tokens[0].type)
        expect(actual_tokens[0].value).to eq(expected_tokens[0].value)
      end
    end
  end
end
