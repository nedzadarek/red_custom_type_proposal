Red [
  info: %../readme.md
]
do %../main.red ; run main file
do %_helpers.red

; When you don't provide parser for a type it should return:
comment {
  [
  "custom-type"
  type-name
  type-value
  ]
}

totaly-not-a-tree-code: {
  a: 42

  tree1: totaly-not-a-tree#{_
    tree(
      tree (leaf 1 leaf)
      2
      tree (leaf 3 leaf)
    )
  _}
  b: 21 * 2
}
parse-type totaly-not-a-tree-code
do load totaly-not-a-tree-code
tree1-expected-value: [
  "custom-type"
  "totaly-not-a-tree"
  {^/    tree(^/      tree (leaf 1 leaf)^/      2^/      tree (leaf 3 leaf)^/    )^/  }
]
assert tree1-expected-value [tree1]
assert/string 42 [b] "Other values should be fine"
