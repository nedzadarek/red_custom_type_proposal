Red [
  info: %../readme.md
]

do %../main.red ; run main file
do %_helpers.red
do %../ct-functions.red
do %coordinates.red

print ["#################################"]
print ["||| Custom types in functions: |||"]
print ["#################################"]
pal: :parse-and-load
ct1-ro: ct-func [a ["polar"] ] [reduce ["ro: " a/ro]]
assert ["ro: " 3.14] [ct1-ro pal"polar#3.14<1.0"]
assert ["ro: " 42.0] [ct1-ro pal"polar#42.0<1.1"]

polar1: pal"polar#2.3<3.3"
assert ["ro: " 2.3] [ct1-ro polar1]

ct2-polar-equal: ct-func [
  p1 ["polar"]
  p2 ["polar"]
][
  ; just to make sure it returns true or false
  to-logic all [
    p1/ro = p2/ro
    p1/theta = p2/theta
  ]
]


assert true [ct2-polar-equal pal"polar#2.2<3.3" pal"polar#2.2<3.3"]
assert false [ct2-polar-equal pal"polar#2.2<3.3" pal"polar#2.2<3.4"]
