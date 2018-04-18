Red [
  info: %../readme.md
]
do %../main.red ; run main file
do %_helpers.red

type-parsers/("foo"): func [src /local o][
  o: (make object! [
    custom-type: true
    type-name: "foo"
    value: 10 * to-integer src
  ])
  return mold/all o
]
code: "a: foo#42"
parse-type code

expected: make object![
  custom-type: true
  type-name: "foo"
  value: 420
]


assert expected [do load code ]
