Red [
  info: %../readme.md
]
do %../main.red ; run main file
do %_helpers.red

type-parsers/("tree"): func [
  src [string!]
  /local whitespace number
  rule-leaf rule-value rule-branches
][
  trim/head/tail src
  rule-leaf: ["leaf" keep ("'leaf")  ]
  whitespace: charset [" " "^/"]
  number: charset [#"0" - #"9"]
  rule-value: [some number]
  rule-branches: [
    [any whitespace]
    "tree"
    keep (
      {
      make object! [
        type: 'custom-type
        type-name: "tree"
      }
    )
    [any whitespace]
    "(" [any whitespace]
      keep("left: ") [rule-leaf | rule-branches]

      [any whitespace]
      keep ("value: ") keep rule-value
      [any whitespace]

      keep ("right: ") [rule-leaf | rule-branches]
      [any whitespace]

    ")"
    keep ("]")
  ]

  return form parse src [collect [rule-leaf | rule-branches] ]
]
tree-code: {
  a: 42

  tree1: tree#{_
    tree(
      tree (leaf 1 leaf)
      2
      tree (leaf 3 leaf)
    )
  _}
  b: 21 * 2
}
parse-type tree-code
; print tree-code
do load tree-code

assert 'leaf [tree1/left/left]
assert 1 [tree1/left/value]
assert 42 [a]
assert 42 [b]
expected-tree: make object! [
    type: 'custom-type
    type-name: "tree"
    left: make object! [
        type: 'custom-type
        type-name: "tree"
        left: 'leaf
        value: 1
        right: 'leaf
    ]
    value: 2
    right: make object! [
        type: 'custom-type
        type-name: "tree"
        left: 'leaf
        value: 3
        right: 'leaf
    ]
]
assert expected-tree [tree1]
