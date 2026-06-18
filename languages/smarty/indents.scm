; Indent the body of each paired block construct and align the closing tag
; with its opening tag. Zed uses a relative model: @start marks where the
; indent begins (just after the opening tag) and @end where it ends (just
; before the closing tag).
;
; Branch keywords ({elseif}, {else}, {foreachelse}, ...) stay at the body's
; indent level; this keeps indentation stable and error-free while editing.

(block
  (start_tag) @start
  (end_tag) @end) @indent

(if_block
  (if_start_tag) @start
  (if_end_tag) @end) @indent

(for_block
  (for_start_tag) @start
  (for_end_tag) @end) @indent

(foreach_block
  (foreach_start_tag) @start
  (foreach_end_tag) @end) @indent

(while_block
  (while_start_tag) @start
  (while_end_tag) @end) @indent

(section_block
  (section_start_tag) @start
  (section_end_tag) @end) @indent

(literal_block
  (literal_start_tag) @start
  (literal_end_tag) @end) @indent

; Indent the contents of multi-line expression brackets.
(parenthesized_expression
  "(" @start
  ")" @end) @indent

(array
  "[" @start
  "]" @end) @indent
