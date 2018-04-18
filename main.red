Red [
  author: "Darek Nędza"
  version: 0.0.0
  version-type: 'alpha
  license: "see readme.md"
]
unless value? 'type-parsers  [type-parsers: make map! []]

parse-type: func [
  source [string!]
  /local .letter .type-name .separator .whitespaces .printables
    .rule-basic-form ._name ._value
    .extended-form-start-symbol .extended-form-end-symbol
    .rule-extended-form
    .fun
][
  .letter: charset [#"a" - #"z" #"A" - #"Z"]
  .type-name: [copy ._name [some [.letter | "_" | "-"]]]
  .separator: #"#"
  .whitespaces: charset rejoin [space tab newline]
  .printables: complement .whitespaces
  .value: [copy ._value some .printables]
  .rule-basic-form: [.type-name .separator .value]

  .extended-form-start-symbol: "{_"
  .extended-form-end-symbol:   "_}"
  .rule-extended-form: [
    copy ._name .type-name
    .separator
    .extended-form-start-symbol copy ._value to .extended-form-end-symbol
    .extended-form-end-symbol
  ]
  .rule-mixed-form: [
    any [
      thru
      change
        [.rule-extended-form | .rule-basic-form]
        ( ; bug - a/(foo) returns `fooo` - wrap it in the parens or put function in the word
          fun: :type-parsers/(._name)
          either :fun [
            fun ._value
          ][
            mold reduce["custom-type" ._name ._value]
          ]
        )
    ]
    thru end
  ]
  parse source .rule-mixed-form
]
