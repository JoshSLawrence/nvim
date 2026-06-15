; Treesitter query to find HTML class attributes
; Captures class attribute values as @tailwind

(attribute
  (attribute_name) @_attr_name
  (#eq? @_attr_name "class")
  (quoted_attribute_value
    (attribute_value) @tailwind))
