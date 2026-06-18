; Match the braces of an individual tag.
(tag "{" @open "}" @close)
(start_tag "{" @open "}" @close)
(end_tag "{/" @open "}" @close)

; Match the opening and closing tags of paired block constructs.
(block
  (start_tag) @open
  (end_tag) @close)

(if_block
  (if_start_tag) @open
  (if_end_tag) @close)

(for_block
  (for_start_tag) @open
  (for_end_tag) @close)

(foreach_block
  (foreach_start_tag) @open
  (foreach_end_tag) @close)

(while_block
  (while_start_tag) @open
  (while_end_tag) @close)

(section_block
  (section_start_tag) @open
  (section_end_tag) @close)

(literal_block
  (literal_start_tag) @open
  (literal_end_tag) @close)

; Match expression brackets.
(parenthesized_expression "(" @open ")" @close)
(arguments "(" @open ")" @close)
(array "[" @open "]" @close)
