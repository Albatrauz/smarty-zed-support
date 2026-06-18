; Show paired block constructs ({block}, {capture}, {function}, {strip}, ...)
; in the document outline, labelled by their tag name.
(block
  (start_tag
    "{" @context
    (tag_function
      (tag_function_name) @name))) @item
