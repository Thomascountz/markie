require "rspec"
require "markie"

RSpec.describe Markie do
  describe ".to_html" do
    describe "compiles markdown to HTML" do
      it "it returns html" do
        markdown = "[Markie](https://github.com/Thomascountz/markie) isn't _the_ best, but it's fun!"
        expected_html = "<body><p><a href=\"https://github.com/Thomascountz/markie\">Markie</a> isn't <em>the</em> best, but it's fun!</p></body>"

        html = Markie.to_html(markdown)

        expect(html).to eq(expected_html)
      end
    end
  end
end
