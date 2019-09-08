module Markie
  class Generator
    class << self
      def generate(ast)
        body(ast)
      end

      private

      def body(node)
        content = node.children.map { |child|
          paragraph(child)
        }.join("")

        "<body>#{content}</body>"
      end

      def paragraph(node)
        content = node.children.map { |child|
          if child.type == :text
            text(child)
          elsif child.type == :link
            link(child)
          elsif child.type == :emphasis
            emphasis(child)
          end
        }.join("")

        "<p>#{content}</p>"
      end

      def text(node)
        node.value
      end

      def link(node)
        "<a href=\"#{node.value}\">#{text(node.children[0])}</a>"
      end

      def emphasis(node)
        "<em>#{node.value}</em>"
      end
    end
  end
end
