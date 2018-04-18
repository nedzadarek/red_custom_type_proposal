Red [
  info: %../readme.md
]
do %../main.red ; run main file
do %_helpers.red


type-parsers/("multi"): func [src [string!] /local obj][
  obj: (make object! [
    custom-type: true
    type-name: "multi"
    value: reverse src
  ])
  return mold/all obj
]
multi-code: {
  a: 42
  m: multi#{_
    0
    1
  _}
}
parse-type multi-code

expected: make object! [
    custom-type: true
    type-name: "multi"
    value: {  ^/1    ^/0    ^/}
]
do load multi-code
assert/string expected [m] "Extended forms"
