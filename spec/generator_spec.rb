require "rspec"
require "markie/node"
require "markie/generator"

RSpec.describe Markie::Generator do
  describe ".generate" do
    describe "generating HTML from an empty ast" do
      it "it returns html" do
        ast = Markie::Node.new(type: :body, token_count: 0, children: [
          Markie::Node.new(type: :paragraph, token_count: 0, children: []),
        ])

        html = Markie::Generator.generate(ast)

        expect(html).to eq("<body><p></p></body>")
      end
    end

    describe "generating HTML from a text node inside of a paragraph node" do
      it "it returns html" do
        ast = Markie::Node.new(type: :body, token_count: 1, children: [
          Markie::Node.new(type: :paragraph, token_count: 1, children: [
            Markie::Node.new(type: :text, token_count: 1, value: "text", children: []),
          ]),
        ])

        html = Markie::Generator.generate(ast)

        expect(html).to eq("<body><p>text</p></body>")
      end
    end

    describe "generating HTML from a link node inside of a paragraph node" do
      it "it returns html" do
        ast = Markie::Node.new(type: :body, token_count: 6, children: [
          Markie::Node.new(type: :paragraph, token_count: 6, children: [
            Markie::Node.new(type: :link, token_count: 6, value: "link_url", children: [
              Markie::Node.new(type: :text, token_count: 1, value: "link_text", children: []),
            ]),
          ]),
        ])

        html = Markie::Generator.generate(ast)

        expect(html).to eq("<body><p><a href=\"link_url\">link_text</a></p></body>")
      end
    end

    describe "generating HTML from a emphasis node inside of a paragraph node" do
      it "it returns html" do
        ast = Markie::Node.new(type: :body, token_count: 1, children: [
          Markie::Node.new(type: :paragraph, token_count: 1, children: [
            Markie::Node.new(type: :emphasis, token_count: 1, value: "emphasis_text", children: []),
          ]),
        ])

        html = Markie::Generator.generate(ast)

        expect(html).to eq("<body><p><em>emphasis_text</em></p></body>")
      end
    end
  end

  describe "generating HTML from an abstract syntax tree" do
    it "it returns html" do
      ast = Markie::Node.new(type: :body, token_count: 11, children: [
        Markie::Node.new(type: :paragraph, token_count: 1, children: [
          Markie::Node.new(type: :link, token_count: 6, value: "https://github.com/Thomascountz/markie", children: [
            Markie::Node.new(type: :text, token_count: 1, value: "Markie", children: []),
          ]),
          Markie::Node.new(type: :text, token_count: 1, value: " isn't ", children: []),
          Markie::Node.new(type: :emphasis, token_count: 1, value: "the", children: []),
          Markie::Node.new(type: :text, token_count: 1, value: " best, but it's fun!", children: []),
        ]),
      ])

      html = Markie::Generator.generate(ast)

      expect(html).to eq("<body><p><a href=\"https://github.com/Thomascountz/markie\">Markie</a> isn't <em>the</em> best, but it's fun!</p></body>")
    end
  end
end
