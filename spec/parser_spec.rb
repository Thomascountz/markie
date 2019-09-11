require "rspec"
require "markie/parser"

RSpec.describe Markie::Parser do
  describe ".parse" do
    describe "parsing an eof token" do
      it "returns an abstract syntax tree" do
        tokens = [Markie::Token.new(type: :eof, value: "")]

        body = Markie::Parser.parse(tokens)

        expect(body.type).to eq(:body)
        expect(body.token_count).to eq(1)
        expect(body.children.length).to eq(1)

        paragraph = body.children[0]
        expect(paragraph.type).to eq(:paragraph)
        expect(paragraph.token_count).to eq(1)
        expect(paragraph.children.length).to eq(0)
      end
    end

    describe "parsing a single text token" do
      it "returns an abstract syntax tree" do
        tokens = [Markie::Token.new(type: :text, value: "foo"),
                  Markie::Token.new(type: :eof, value: ""),]

        body = Markie::Parser.parse(tokens)

        expect(body.type).to eq(:body)
        expect(body.token_count).to eq(2)
        expect(body.children.length).to eq(1)

        paragraph = body.children[0]
        expect(paragraph.type).to eq(:paragraph)
        expect(paragraph.token_count).to eq(2)
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
        tokens = [Markie::Token.new(type: :underscore, value: "_"),
                  Markie::Token.new(type: :text, value: "emphasis_foo"),
                  Markie::Token.new(type: :underscore, value: "_"),
                  Markie::Token.new(type: :eof, value: ""),]

        body = Markie::Parser.parse(tokens)

        expect(body.type).to eq(:body)
        expect(body.token_count).to eq(4)
        expect(body.children.length).to eq(1)

        paragraph = body.children[0]
        expect(paragraph.type).to eq(:paragraph)
        expect(paragraph.token_count).to eq(4)
        expect(paragraph.children.length).to eq(1)

        emphasis_text = paragraph.children[0]
        expect(emphasis_text.type).to eq(:emphasis)
        expect(emphasis_text.token_count).to eq(3)
        expect(emphasis_text.value).to eq("emphasis_foo")
        expect(emphasis_text.children.length).to eq(0)
      end

      it "returns an abstract syntax tree" do
        tokens = [Markie::Token.new(type: :asterisk, value: "*"),
                  Markie::Token.new(type: :text, value: "emphasis_foo"),
                  Markie::Token.new(type: :asterisk, value: "*"),
                  Markie::Token.new(type: :eof, value: ""),]

        body = Markie::Parser.parse(tokens)

        expect(body.type).to eq(:body)
        expect(body.token_count).to eq(4)
        expect(body.children.length).to eq(1)

        paragraph = body.children[0]
        expect(paragraph.type).to eq(:paragraph)
        expect(paragraph.token_count).to eq(4)
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
        tokens = [Markie::Token.new(type: :open_square_bracket, value: "["),
                  Markie::Token.new(type: :text, value: "link_text"),
                  Markie::Token.new(type: :close_square_bracket, value: "]"),
                  Markie::Token.new(type: :open_parenthesis, value: "("),
                  Markie::Token.new(type: :text, value: "link_url"),
                  Markie::Token.new(type: :close_parenthesis, value: ")"),
                  Markie::Token.new(type: :eof, value: ""),]

        body = Markie::Parser.parse(tokens)

        expect(body.type).to eq(:body)
        expect(body.token_count).to eq(7)
        expect(body.children.length).to eq(1)

        paragraph = body.children[0]
        expect(paragraph.type).to eq(:paragraph)
        expect(paragraph.token_count).to eq(7)
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

    describe "parsing multiple paragraphs" do
      it "returns an abstract syntax tree" do
        tokens = [Markie::Token.new(type: :text, value: "first paragraph"),
                  Markie::Token.new(type: :newline, value: ""),
                  Markie::Token.new(type: :newline, value: ""),
                  Markie::Token.new(type: :text, value: "second paragraph"),
                  Markie::Token.new(type: :eof, value: ""),]

        body = Markie::Parser.parse(tokens)

        expect(body.type).to eq(:body)
        expect(body.token_count).to eq(5)
        expect(body.children.length).to eq(2)

        paragraph1 = body.children[0]
        expect(paragraph1.type).to eq(:paragraph)
        expect(paragraph1.token_count).to eq(3)
        expect(paragraph1.children.length).to eq(1)

        text1 = paragraph1.children[0]
        expect(text1.type).to eq(:text)
        expect(text1.token_count).to eq(1)
        expect(text1.value).to eq("first paragraph")
        expect(text1.children.length).to eq(0)

        paragraph2 = body.children[1]
        expect(paragraph2.type).to eq(:paragraph)
        expect(paragraph2.token_count).to eq(2)
        expect(paragraph2.children.length).to eq(1)

        text2 = paragraph2.children[0]
        expect(text2.type).to eq(:text)
        expect(text2.token_count).to eq(1)
        expect(text2.value).to eq("second paragraph")
        expect(text2.children.length).to eq(0)
      end
    end

    describe "parsing different tokens" do
      it "returns an abstract syntax tree" do
        tokens = [Markie::Token.new(type: :asterisk, value: "*"),
                  Markie::Token.new(type: :text, value: "This"),
                  Markie::Token.new(type: :asterisk, value: "*"),
                  Markie::Token.new(type: :text, value: " is "),
                  Markie::Token.new(type: :underscore, value: "_"),
                  Markie::Token.new(type: :text, value: "mine"),
                  Markie::Token.new(type: :underscore, value: "_"),
                  Markie::Token.new(type: :text, value: " "),
                  Markie::Token.new(type: :open_square_bracket, value: "["),
                  Markie::Token.new(type: :text, value: "link_text"),
                  Markie::Token.new(type: :close_square_bracket, value: "]"),
                  Markie::Token.new(type: :open_parenthesis, value: "("),
                  Markie::Token.new(type: :text, value: "link_url"),
                  Markie::Token.new(type: :close_parenthesis, value: ")"),
                  Markie::Token.new(type: :eof, value: ""),]

        body = Markie::Parser.parse(tokens)

        expect(body.type).to eq(:body)
        expect(body.token_count).to eq(15)
        expect(body.children.length).to eq(1)

        paragraph = body.children[0]
        expect(paragraph.type).to eq(:paragraph)
        expect(paragraph.token_count).to eq(15)
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
