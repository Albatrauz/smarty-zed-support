; Treat the literal text between Smarty tags as a single combined HTML
; document. The HTML grammar in turn injects CSS (<style>) and JS (<script>).
((text) @injection.content
  (#set! injection.combined)
  (#set! injection.language "html"))
