require "rspec"
require "parser"

RSpec.describe Parser do
  describe ".parse" do
    describe "parsing an eof token" do
      it "returns an abstract syntax tree" do
        tokens = [Token.new(type: :eof, value: "")]

        body = Parser.parse(tokens)

        expect(body.type).to eq(:body)
        expect(body.token_count).to eq(0)
        expect(body.children.length).to eq(1)

        paragraph = body.children[0]
        expect(paragraph.type).to eq(:paragraph)
        expect(paragraph.token_count).to eq(0)
        expect(paragraph.children.length).to eq(0)
      end
    end

    describe "parsing a single text token" do
      it "returns an abstract syntax tree" do
        tokens = [Token.new(type: :text, value: "foo"),
                  Token.new(type: :eof, value: ""),]

        body = Parser.parse(tokens)

        expect(body.type).to eq(:body)
        expect(body.token_count).to eq(1)
        expect(body.children.length).to eq(1)

        paragraph = body.children[0]
        expect(paragraph.type).to eq(:paragraph)
        expect(paragraph.token_count).to eq(1)
        expect(paragraph.children.length).to eq(1)

        text = paragraph.children[0]
        expect(text.type).to eq(:text)
        expect(text.token_count).to eq(1)
        expect(text.value).to eq("foo")
        expect(text.children.length).to eq(0)
      end
    end

    describe "parsing an emphasized text token" do
      it "returns an abstract syntax tree" do
        tokens = [Token.new(type: :underscore, value: "_"),
                  Token.new(type: :text, value: "emphasis_foo"),
                  Token.new(type: :underscore, value: "_"),
                  Token.new(type: :eof, value: ""),]

        body = Parser.parse(tokens)

        expect(body.type).to eq(:body)
        expect(body.token_count).to eq(3)
        expect(body.children.length).to eq(1)

        paragraph = body.children[0]
        expect(paragraph.type).to eq(:paragraph)
        expect(paragraph.token_count).to eq(3)
        expect(paragraph.children.length).to eq(1)

        emphasis_text = paragraph.children[0]
        expect(emphasis_text.type).to eq(:emphasis)
        expect(emphasis_text.token_count).to eq(3)
        expect(emphasis_text.value).to eq("emphasis_foo")
        expect(emphasis_text.children.length).to eq(0)
      end

      it "returns an abstract syntax tree" do
        tokens = [Token.new(type: :asterisk, value: "*"),
                  Token.new(type: :text, value: "emphasis_foo"),
                  Token.new(type: :asterisk, value: "*"),
                  Token.new(type: :eof, value: ""),]

        body = Parser.parse(tokens)

        expect(body.type).to eq(:body)
        expect(body.token_count).to eq(3)
        expect(body.children.length).to eq(1)

        paragraph = body.children[0]
        expect(paragraph.type).to eq(:paragraph)
        expect(paragraph.token_count).to eq(3)
        expect(paragraph.children.length).to eq(1)

        emphasis_text = paragraph.children[0]
        expect(emphasis_text.type).to eq(:emphasis)
        expect(emphasis_text.token_count).to eq(3)
        expect(emphasis_text.value).to eq("emphasis_foo")
        expect(emphasis_text.children.length).to eq(0)
      end
    end

    describe "parsing a link token" do
      it "returns an abstract syntax tree" do
        tokens = [Token.new(type: :open_square_bracket, value: "["),
                  Token.new(type: :text, value: "link_text"),
                  Token.new(type: :close_square_bracket, value: "]"),
                  Token.new(type: :open_parenthesis, value: "("),
                  Token.new(type: :text, value: "link_url"),
                  Token.new(type: :close_parenthesis, value: ")"),
                  Token.new(type: :eof, value: ""),]

        body = Parser.parse(tokens)

        expect(body.type).to eq(:body)
        expect(body.token_count).to eq(6)
        expect(body.children.length).to eq(1)

        paragraph = body.children[0]
        expect(paragraph.type).to eq(:paragraph)
        expect(paragraph.token_count).to eq(6)
        expect(paragraph.children.length).to eq(1)

        link = paragraph.children[0]
        expect(link.type).to eq(:link)
        expect(link.token_count).to eq(6)
        expect(link.value).to eq("link_url")
        expect(link.children.length).to eq(1)

        text = link.children[0]
        expect(text.type).to eq(:text)
        expect(text.token_count).to eq(1)
        expect(text.value).to eq("link_text")
        expect(text.children.length).to eq(0)
      end
    end

    describe "parsing different tokens" do
      it "returns an abstract syntax tree" do
        tokens = [Token.new(type: :asterisk, value: "*"),
                  Token.new(type: :text, value: "This"),
                  Token.new(type: :asterisk, value: "*"),
                  Token.new(type: :text, value: " is "),
                  Token.new(type: :underscore, value: "_"),
                  Token.new(type: :text, value: "mine"),
                  Token.new(type: :underscore, value: "_"),
                  Token.new(type: :text, value: " "),
                  Token.new(type: :open_square_bracket, value: "["),
                  Token.new(type: :text, value: "link_text"),
                  Token.new(type: :close_square_bracket, value: "]"),
                  Token.new(type: :open_parenthesis, value: "("),
                  Token.new(type: :text, value: "link_url"),
                  Token.new(type: :close_parenthesis, value: ")"),
                  Token.new(type: :eof, value: ""),]

        body = Parser.parse(tokens)

        expect(body.type).to eq(:body)
        expect(body.token_count).to eq(14)
        expect(body.children.length).to eq(1)

        paragraph = body.children[0]
        expect(paragraph.type).to eq(:paragraph)
        expect(paragraph.token_count).to eq(14)
        expect(paragraph.children.length).to eq(5)

        emphasis = paragraph.children[0]
        expect(emphasis.type).to eq(:emphasis)
        expect(emphasis.token_count).to eq(3)
        expect(emphasis.value).to eq("This")
        expect(emphasis.children.length).to eq(0)

        text = paragraph.children[1]
        expect(text.type).to eq(:text)
        expect(text.token_count).to eq(1)
        expect(text.value).to eq(" is ")
        expect(text.children.length).to eq(0)

        emphasis2 = paragraph.children[2]
        expect(emphasis2.type).to eq(:emphasis)
        expect(emphasis2.token_count).to eq(3)
        expect(emphasis2.value).to eq("mine")
        expect(emphasis2.children.length).to eq(0)

        space = paragraph.children[3]
        expect(space.type).to eq(:text)
        expect(space.token_count).to eq(1)
        expect(space.value).to eq(" ")
        expect(space.children.length).to eq(0)

        link = paragraph.children[4]
        expect(link.type).to eq(:link)
        expect(link.token_count).to eq(6)
        expect(link.value).to eq("link_url")
        expect(link.children.length).to eq(1)

        link_text = link.children[0]
        expect(link_text.type).to eq(:text)
        expect(link_text.token_count).to eq(1)
        expect(link_text.value).to eq("link_text")
        expect(link_text.children.length).to eq(0)
      end
    end
  end
end
