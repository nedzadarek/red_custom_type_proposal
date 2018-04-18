Red [
  info: %../readme.md
]
assert: func [
  expected
  returned [block!] "Code to execute"
  /string
  str [string!] "String to print"
  /local

  executed
] [
  print "#################"
  unless string [
    str: copy mold expected
    append str " || "
    append str mold returned
  ]
  executed: try returned
  either error? executed [
    print executed
  ][
    either expected = executed [
      print [str "=>"  "Equal"]
    ][
      print [
        either string [str "=>^/"] [""]
        "Expected is not equal returned value::^/"
        ">>> Expected: " expected "^/"
        ">>> Returned: " executed
      ]
    ]
  ]

]
; assert 2 [1 + 1]
; assert 2 [1 + 2]
;
; assert/string 2 [1 + 1] "good sum"
; assert/string 2 [1 + 2] "bad sum"
