Red [
  info: %../readme.md
]
do %../main.red ; run main file
do %_helpers.red


;  "a: cartesian#2x3 b: polar#3.605551275463989<0.9827937232473291"
type-parsers/("cartesian"): func [
  value [string!]
  /local number symbol x y obj
][
  digit: charset [#"0" - #"9"]
  number: [some digit]
  symbol: #"x"
  parse value [
    copy x number
    symbol
    copy y number
  ]

  ; make object creator so you don't have to type so much
  obj: (
    make object! compose [
      type: 'custom-type
      type-name: "cartesian"
      type-value: (value)

      x: (to-integer x)
      y: (to-integer y)

      cartesian: true

      to-polar: has [ro theta] [
        ro: square-root ((x ** 2) + (y ** 2))
        theta: atan2 y x
        return make object! compose [
          type-name: "polar"
          ro: (ro)
          theta: (theta)
        ]
      ]
    ]
  )
  return mold/all obj
]

type-parsers/("polar"): func[
  value [string!]
  /local digit float-symbol float-numbers symbol ro theta obj
][
  digit: charset [#"0" - #"9"]
  float-symbol: #"."
  float-numbers: [some digit float-symbol some digit]
  symbol: #"<"
  parse value [
    copy ro float-numbers
    symbol
    copy theta float-numbers
  ]
  obj: (
    make object! compose [
      type: 'custom-type
      type-name: "polar"
      type-value: (value)

      ro: (to-float ro)
      theta: (to-float theta)
      polar: true
      to-cartesian: has [x y][
        x: ro * cos theta
        y: ro * sin theta
        return make object! compose [
          type-name: "cartesian"
          x: (to-integer x)
          y: (to-integer y)
        ]
      ]
    ]
  )
  return mold/all obj
]


code: "a: 42 cart1: cartesian#2x21 pol1: polar#2.2<3.3  b: 3.14"
parse-type code
do load code
pol1-expected: make object! [
    type: 'custom-type
    type-name: "polar"
    type-value: "2.2<3.3"
    ro: 2.2
    theta: 3.3
    polar: true
    to-cartesian: func [/local x y][x: ro * cos theta
        y: ro * sin theta
        return make object! compose [
            type-name: "cartesian"
            x: (to-integer x) y: (to-integer y)
        ]
    ]
]
assert/string (mold pol1-expected) [mold pol1] "polar coordinates"
assert pol1-expected/ro [2.2]

cart1-expected: cart1: make object! [
    type: 'custom-type
    type-name: "cartesian"
    type-value: "2x21"
    x: 2
    y: 21
    cartesian: true
    to-polar: func [/local ro theta][ro: square-root ((x ** 2) + (y ** 2))
        theta: atan2 y x
        return make object! compose [
            type-name: "polar"
            ro: (ro) theta: (theta)
        ]
    ]
]
assert mold cart1-expected [mold cart1]
assert cart1/x [2]
