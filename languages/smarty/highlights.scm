; Tag and expression delimiters
[
  "{"
  "}"
  "{/"
  "["
  "]"
  "("
  ")"
] @punctuation.bracket

[
  ","
  ":"
  "`"
] @punctuation.delimiter

; Operators
[
  "="
  "=>"
  "->"
  "."
  "|"
  "!"

  "+"
  "-"
  "*"
  "/"
  "%"
  "**"

  "++"
  "--"

  "=="
  "!="
  "<>"
  ">"
  "<"
  ">="
  "<="
  "==="
  "!=="

  "??"
  "?:"

  "&&"
  "||"
] @operator

(ternary_expression
  ["?" ":"] @operator)

; Word operators
[
  "and"
  "or"
  "xor"
  "not"
  "eq"
  "ne"
  "neq"
  "gt"
  "lt"
  "gte"
  "ge"
  "lte"
  "le"
  "mod"
  "div"
  "by"
  "in"
  "is"
  "even"
  "odd"
  "to"
  "as"
] @keyword.operator

; Built-in control-flow keywords
[
  "if"
  "else"
  "elseif"
  "for"
  "forelse"
  "foreach"
  "foreachelse"
  "literal"
  "section"
  "sectionelse"
  "while"
] @keyword.control

; Tag function names — {include}, {assign}, {capture}, {block}, custom tags, ...
(tag_function_name) @function

; Tag attribute names
(tag_function_attribute
  name: (identifier) @attribute)

; Comments
(comment) @comment

; Variables
(variable) @variable
(variable "$" @punctuation.special)
(config_variable) @variable
(config_variable "#" @punctuation.special)

; The built-in $smarty superglobal
(variable
  (identifier) @variable.special
  (#eq? @variable.special "smarty"))

; Loop/iterator properties: $item@index, $item@first, ...
(variable_property
  property: (identifier) @variable.special
  (#any-of? @variable.special "index" "iteration" "first" "last" "show" "total"))
(variable_property "@" @operator)

; Member access and method calls
(member_access_expression
  name: (identifier) @property)
(member_call_expression
  name: (identifier) @function.method)
(section_access_expression
  name: (identifier) @property)
(smarty_access_expression
  name: (identifier) @property)

; $smarty.const.FOO — highlight FOO as a constant
(smarty_access_expression
  array: (smarty_access_expression
    array: (variable
      (identifier) @variable.special (#eq? @variable.special "smarty"))
    name: (identifier) @property (#eq? @property "const"))
  name: (identifier) @constant)

; Function and modifier calls
(modifier_call_expression
  name: (identifier) @function)
(function_call_expression
  name: (identifier) @function)

; Literals
(null) @constant.builtin
(boolean) @boolean
(number) @number
(string) @string
(escape_sequence) @string.escape
