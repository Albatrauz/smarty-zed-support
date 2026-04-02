; Block-level constructs that increase indent
(if_block) @indent
(for_block) @indent
(foreach_block) @indent
(while_block) @indent
(section_block) @indent
(literal_block) @indent
(block) @indent

; End tags that decrease indent
(if_end_tag "}" @end) @dedent
(for_end_tag "}" @end) @dedent
(foreach_end_tag "}" @end) @dedent
(while_end_tag "}" @end) @dedent
(section_end_tag "}" @end) @dedent
(literal_end_tag "}" @end) @dedent
(end_tag "}" @end) @dedent

; Branch alternatives (dedent then re-indent)
(elseif_block) @branch
(else_block) @branch
(forelse_block) @branch
(foreachelse_block) @branch
(sectionelse_block) @branch
