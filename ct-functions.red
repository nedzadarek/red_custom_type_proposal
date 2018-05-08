Red [
  author: "Darek Nędza"
  version: 0.0.0
  version-type: 'alpha
  license: "see readme.md"
]

ct-func: func [
  spec [block!]
  body [block!]
  /local
    datatypes ; built-in types
    raise ; for throwing errors
    _word
    type-rule
    pos
    type
    word
    custom-types-per-word
    custom-types
    key
    type-checks
    possible-types
] [
  ; https://gitter.im/red/help?at=5af050b897e5506e04a32977
  datatypes: collect [
    foreach _word words-of system/words [
      if datatype? get/any _word [keep _word]
    ]
  ]

  raise: func [message] [
    cause-error 'user 'message append copy [] rejoin message
  ]

  type-rule: [
    pos: set type skip :pos

    [
      [
        string! if (find type-parsers type)
        keep (type)
        change pos object!
      ]
      | word! if (find datatypes type)
      | (raise [type " is not a type"])
    ]
  ]
  custom-types: make map! []
  main-rule: [
    opt string! ; description
    opt block! ; attributes

    any collect [
      set word word!

      opt [
        ahead block! into [
          collect set custom-types-per-word any [type-rule]
          (custom-types/(word): custom-types-per-word)
        ]
      ]
      opt string! ; word description
    ]
    ; do refinements!!!!!
    any [refinement! opt word! opt block! opt string!]
  ]

  ; remove words that doesn't have custom types
  foreach key keys-of custom-types [
    if custom-types/(key) = [] [custom-types/(key): none]
  ]

  type-checks: copy []
  possible-types: copy []
  foreach key keys-of custom-types[
    ; check if word is custom-type
    append type-checks compose [
      unless 'custom-type = get in (reduce key) 'type [
        raise [key " is not a custom type"]
      ]
    ]

    ; check if word is custom-type of given type
    possible-types: copy []
    foreach _type custom-types [
      append possible-types _type
    ]
    append type-checks compose [
      unless find (possible-types) get in (reduce key) 'type-name [
        raise [key " is not a custom-type of type: " type]
      ]
    ]
  ]

  parse spec main-rule
  func spec (insert body type-checks)
]
parse-and-load: func [src] [
  parse-type src
  do load src
]
