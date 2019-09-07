# Markie <img src="https://i.postimg.cc/wxXhdwZr/markie-2.jpg" alt="relay logo" width="100" align="right"/>


Proof-of-concept Markdown to HTML compiler in Ruby


## Grammar v.`c28ab7d`

```
Body           := Paragraph*
Paragraph      := Sentence+ <NEWLINE> <NEWLINE>
                | Sentence+ <EOF>
Sentence       := Text
                | Emphasis
                | Link
Text           := <TEXT>
Emphasis       := <UNDERSCORE> <TEXT> <UNDERSCORE>
                | <ASTERISK> <TEXT> <ASTERISK>
Link           := <OPEN_SQUARE_BRACKET> <TEXT> <CLOSED_SQUARE_BRACKET> <OPEN_PARENTHESIS> <TEXT> <CLOSED_PARENTHESIS>
```


## Example v.`c28ab7d`

```ruby
markdown = "[Markie](https://github.com/Thomascountz/markie) isn't _the_ best, but it's fun!"
=> "[Markie](https://github.com/Thomascountz/markie) isn't _the_ best, but it's fun!"

tokens = Tokenizer.tokenize(markdown)
=> [#<Token:0x00007ff253247af0 @type=:open_square_bracket, @value="[">,
 #<Token:0x00007ff25327f298 @type=:text, @value="Markie">,
 #<Token:0x00007ff253287970 @type=:close_square_bracket, @value="]">,
 #<Token:0x00007ff25328fe68 @type=:open_parenthesis, @value="(">,
 #<Token:0x00007ff2539299b8 @type=:text, @value="https://github.com/Thomascountz/markie">,
 #<Token:0x00007ff253933be8 @type=:close_parenthesis, @value=")">,
 #<Token:0x00007ff253940910 @type=:text, @value=" isn't ">,
 #<Token:0x00007ff25394b7e8 @type=:underscore, @value="_">,
 #<Token:0x00007ff253951b70 @type=:text, @value="the">,
 #<Token:0x00007ff253950c70 @type=:underscore, @value="_">,
 #<Token:0x00007ff253316210 @type=:text, @value=" best, but it's fun!">,
 #<Token:0x00007ff2533160d0 @type=:eof, @value="">]

ast = Parser.parse(tokens)
=> #<Node:0x00007ff2532be538
 @children=
  [#<Node:0x00007ff2532be6f0
    @children=
     [#<Node:0x00007ff2532bf870 @children=[#<Node:0x00007ff2532bfc30 @children=[], @token_count=1, @type=:text, @value="Markie">], @token_count=6, @type=:link, @value="https://github.com/Thomascountz/markie">,
      #<Node:0x00007ff2532bf6e0 @children=[], @token_count=1, @type=:text, @value=" isn't ">,
      #<Node:0x00007ff2532bf398 @children=[], @token_count=3, @type=:emphasis, @value="the">,
      #<Node:0x00007ff2532be880 @children=[], @token_count=1, @type=:text, @value=" best, but it's fun!">],
    @token_count=11,
    @type=:paragraph,
    @value=nil>],
 @token_count=11,
 @type=:body,
 @value=nil>

```

```json
{
  "type": "body",
  "token_count": "11",
  "value": "",
  "children": [
    {
      "type": "paragraph",
      "token_count": "11",
      "value": "",
      "children": [
        {
          "type": "link",
          "token_count": "6",
          "value": "https://github.com/Thomascountz/markie",
          "children": [
            {
              "type": "text",
              "token_count": "1",
              "value": "Markie",
              "children": []
            }
          ]
        },
        {
          "type": "text",
          "token_count": "1",
          "value": " isn't ",
          "children": []
        },
        {
          "type": "emphasis",
          "token_count": "3",
          "value": "the",
          "children": []
        },
        {
          "type": "text",
          "token_count": "1",
          "value": " best, but it's fun!",
          "children": []
        }
      ]
    }
  ]
}
```
