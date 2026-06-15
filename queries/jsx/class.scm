; Treesitter query to find JSX className attributes
; Captures className attribute values as @tailwind

; className="..."
(jsx_attribute
  (property_identifier) @_attr_name
  (#eq? @_attr_name "className")
  (string
    (string_fragment) @tailwind))

; class="..." (also valid in JSX)
(jsx_attribute
  (property_identifier) @_attr_name
  (#eq? @_attr_name "class")
  (string
    (string_fragment) @tailwind))
