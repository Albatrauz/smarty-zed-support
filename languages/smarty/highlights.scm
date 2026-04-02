; Punctuation
[
  "{"
  "}"
  "{/"
] @punctuation.bracket

[
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
] @operator

(ternary_expression
  ["?" ":"] @operator)

; Keyword operators (scoped to binary_expression to avoid substring matches)
(binary_expression
  [
    "and"
    "xor"
    "or"
    "div"
    "eq"
    "even"
    "ge"
    "gt"
    "gte"
    "le"
    "lt"
    "lte"
    "mod"
    "ne"
    "neq"
    "not"
    "odd"
    "is"
    "in"
  ] @keyword)

(for_start_tag
  ["to" "by" "as"] @keyword)

(foreach_start_tag
  ["as"] @keyword)

; Control flow keywords
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

; Tag function names (include, assign, etc.)
(tag_function_name) @tag

; Comments
(comment) @comment

; Tag attributes
(tag_function_attribute
  name: (identifier) @attribute)

; Variables
(variable) @variable
(variable "$" @keyword)
(config_variable "#" @keyword)

; Built-in $smarty variable
(variable
  (identifier) @variable.builtin
  (#any-of? @variable.builtin "smarty"))

; Built-in variable properties
(variable_property
  property: (identifier) @variable.builtin
    (#any-of? @variable.builtin "index" "iteration" "first" "last" "show" "total"))
(variable_property "@" @operator)

; Member access and calls
(member_access_expression
  name: (identifier) @property)
(member_call_expression
  name: (identifier) @function)
(section_access_expression
  name: (identifier) @property)
(smarty_access_expression
  name: (identifier) @property)

; $smarty.const.X pattern
(smarty_access_expression
  array: (smarty_access_expression
    array: (variable
      (identifier) @variable.builtin (#eq? @variable.builtin "smarty"))
    name: (identifier) @property (#eq? @property "const"))
  name: (identifier) @constant)

; Function and modifier calls
(modifier_call_expression
  name: (identifier) @function)
(function_call_expression
  name: (identifier) @function)

; Literals
(null) @type.builtin
(boolean) @boolean
(number) @number
(string) @string
(escape_sequence) @string.escape
