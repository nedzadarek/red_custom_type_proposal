# Red's user defined type (proposal)

### Info:
I made a [proposal] about user defined types. I tried to implement it. Here is my try. It is work in progress. Any suggestion/tips are welcome!
### Usage:
#### -> Types:
There are 2 syntaxes:
- simple form: `type-name#type-value` - this doesn't allow spaces, newline etc.
- extended (multiline) form:
```
type-name#{_
      type value with any character except `{_` or `_}`
_}
```

A few user defined types are in [tests](/tests) folder.  
You should check [simple-form.red] and [extended-form.red] for basic usage.  
[no_parser.red] is a case when you did not define a parser for a type.

#### -> Types in functions:
I've implemented simple function creator that can take the custom types (in the form of `string!`). It's in the [ct-functions.red](/ct-functions.red).  
It's very basic:  
- there is no refinement support - however it won't be hard to implement it
- functions are in the word (see point 8 of the next section)
- they are used by calling special function that takes `string!` (e.g `foo pal"polar#2.2<3.3"`). I want it to be called as in the [proposal] (e.g `foo polar#2.2<3.3`)

More info/usage in the [tests](/tests/ct_functions.red).

### Limits, bugs, notes or new features that I want to implement:
When I have tried to implement user defined types many things did not worked or I do not like their form. I learned a lot so here are my thoughts:
1. Extended form can have spaces/newline/tabs at the beginning:  
I am trimming them with `trim/head/tail string` in each type (when needed). Some types may require them so I think mentioned method is ok.

2. Extended form parsing: `block!` vs `string!`:  
  - parsing `block!` is easier - we do not have care about white spaces and many values are parsed already (e.g. `integer!`)
  - `string!` can contain almost everything
  - shall we include extended form with `block!` (e.g. `type-name#[val1 val2]`) for types that do not require power of the `string!`?
3. How to parse extended form types that have other types in it? Using `block!`s would be easier. How to parse them using string parsing:
  - inclusion of simple types:
  ```
    foo#{_
        baz#21
        bar#42
    _}
  ```
  - inclusion of extended types (we cannot simply match `{_` and `_}`):
  ```
    foo#{_
      baz#{_ ... _}
      bar#{_ ... _}
    _}
  ```



4. Simplify object parsing/creation:  
Some part of the parsing is repetitive or it is not easy. With better `parse` or helper functions the process can be simpler.

5. No parser for a type:  
What happens when user does not define a parser for a type? Should it raise an error? Should it parse into some structure to parse it later([no_parser.red])?

6. How and where to keep source of an extended form types? Should every node contain whole source or just its part? Should "child nodes" have source?

7. Separator:  
It should be easy to type (preferably 1 character). It should be visually distinguishable from other values/words (e.g. `-` is used in the word name so `foo-42` is a word `foo-42`, or user mean `foo - 42` or `foo- 42` or ...?). I used `#` because it's not used in the word's name and I can tell apart from other values. It's used by `issues!` and macro system - does it cause any problems?  

8. Where to put the type's functions?:  
  - Should we keep it per word (e.g `object [some-data: 42 function1: ... function2: ...]`) or should we store it in some kind of modules so a word can reference it (e.g `p1/foo` will take `foo` from some kind module `functions/<type of p1>/foo`).
  - What about operators: `<type1> <op!> <type2>`. Will it call `<type1>/<op!> <type2>` or `<type2>/<op!> <type1>`? Should we keep it in some kind of table. For example:
  ```
  [
      [type1 type2 op] fun1
      [type2 type1 op] fun2
  ]
  ```

  - Where should we put function defined by the user?   
  Is it good for some function to be in the word. The same types can differ in a few details. So `foo` in the `p1/foo` can be different than `foo` in the `p2/foo` (`p1` and `p2` is the same custom type). How many custom types will use such feature?

### License:
- no warranty
- use/modify everywhere
- link to this github

### Contributors/thank:
[red/help room] especially 9214 (for parsing helps) and greggirwin for his code that contains parse's change.

[proposal]: https://github.com/red/red/wiki/Proposal:-user-defined-types-(UDT)-and-dependent-types
[red/help room]: https://gitter.im/red/help
[no_parser.red]: (/tests/no_parser.red)
[extended-form.red]: (/tests/extended-form.red)
[simple-form.red]: (/tests/simple-form.red)
