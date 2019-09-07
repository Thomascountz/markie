# Markie <img src="https://i.postimg.cc/wxXhdwZr/markie-2.jpg" alt="markie_logo" width="100" align="right"/>

Proof-of-concept Markdown to HTML compiler Ruby gem. <img src="https://badge.fury.io/rb/markie.svg" alt="markie_gem" width="100" align="right"/>


## Grammar v.`6c20d2a`


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

## Quick Start

Setup Markie for local development
```
$ bin/setup
```

Experiment with Markie

```
$ bin/console
```

Run tests
```
$ rake
```

## Example v.`6c20d2a`

```ruby
markdown = "[Markie](https://github.com/Thomascountz/markie) isn't _the_ best, but it's fun!"
=> "[Markie](https://github.com/Thomascountz/markie) isn't _the_ best, but it's fun!"

tokens = Markie::Tokenizer.tokenize(markdown)
=> [#<Markie::Token:0x00007f942c095c00 @type=:open_square_bracket, @value="[">,
 #<Markie::Token:0x00007f942c115cc0 @type=:text, @value="Markie">,
 #<Markie::Token:0x00007f942c11c2f0 @type=:close_square_bracket, @value="]">,
 #<Markie::Token:0x00007f942c124400 @type=:open_parenthesis, @value="(">,
 #<Markie::Token:0x00007f942d0e7928 @type=:text, @value="https://github.com/Thomascountz/markie">,
 #<Markie::Token:0x00007f942d0e5f10 @type=:close_parenthesis, @value=")">,
 #<Markie::Token:0x00007f942d10d100 @type=:text, @value=" isn't ">,
 #<Markie::Token:0x00007f942d1171a0 @type=:underscore, @value="_">,
 #<Markie::Token:0x00007f942d12dc98 @type=:text, @value="the">,
 #<Markie::Token:0x00007f942d13f5b0 @type=:underscore, @value="_">,
 #<Markie::Token:0x00007f942d19f7f8 @type=:text, @value=" best, but it's fun!">,
 #<Markie::Token:0x00007f942d19f690 @type=:eof, @value="">]

ast = Markie::Parser.parse(tokens)
=> #<Markie::Node:0x00007f942d23a640
 @children=
  [#<Markie::Node:0x00007f942d23a708
    @children=
     [#<Markie::Node:0x00007f942d23aaf0 @children=[#<Markie::Node:0x00007f942d23abb8 @children=[], @token_count=1, @type=:text, @value="Markie">], @token_count=6, @type=:link, @value="https://github.com/Thomascountz/markie">,
      #<Markie::Node:0x00007f942d23aa00 @children=[], @token_count=1, @type=:text, @value=" isn't ">,
      #<Markie::Node:0x00007f942d23a910 @children=[], @token_count=3, @type=:emphasis, @value="the">,
      #<Markie::Node:0x00007f942d23a820 @children=[], @token_count=1, @type=:text, @value=" best, but it's fun!">],
    @token_count=11,
    @type=:paragraph,
    @value=nil>],
 @token_count=11,
 @type=:body,
 @value=nil>
```

### Abstract Syntax Tree as JSON

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
