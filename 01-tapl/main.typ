#import "../setup/conf.typ": *
#import "../setup/theorem.typ": *

#show: thmrules.with(qed-symbol: $square$)

#show: project.with(
  title: "Tapl notes",
  title_page: true,
  compat_title_page: true,
)

= untyped system

== untyped Lambad-Calculus
#exercise[

  5.2.2 :
  $
    "plus" & := lambda m . lambda n . lambda s. lambda z. med m med s med (n med s med z) \
     "suc" & := lambda n . lambda s . lambda z . med s med (n med s med z) \
    "suc"' & := lambda n . lambda s. lambda z . med "plus" med n med (lambda s. lambda z. med s med z)
  $

  5.2.3 : Is it possible to deﬁne multiplication on Church numerals without using plus?
  $
    "mul" := lambda m . lambda n . lambda s .lambda z . med m med (n med s) med z
  $

  5.2.4 : Deﬁne a term for raising one number to the power of another.
  $
    "pow" := lambda m . lambda n . lambda s . lambda z . med n med ("mul" med m) med (lambda s . lambda z . med s med z)
  $

  5.2.5 : Use prd to deﬁne a subtraction function.
  $
    "pair" & := λ f . λ s.λ b. b f s \
     "fst" & := λ p . p "tru" \
     "snd" & := λ p . p "fls" \
      "zz" & := "pair" c_0 c_0 \
      "ss" & := λ p. "pair" med ("snd" med p) med ("plus" med c_1 med ("snd" med p)) \
     "prd" & := λ m. "fst" med (m med "ss" med "zz") \
     "sub" & := lambda m . lambda n . med n med ("prd" med m) med z \
  $

  5.2.7 : Write a function equal that tests two numbers for equality and returns a Church boolean. For example,
]

== de Bruijn index

#exercise[

  6.1.1
  $
    c_0 := lambda s . lambda z . med z &==>^"nameless" lambda . lambda . med 0 \
    c_2 := lambda s . lambda z . med s med (s med z) &==>^"nameless" lambda . lambda . med 1 med (1 med 0) \
    "plus" := lambda m .lambda n . lambda s . lambda z . med m med s med (n med z med s) & ==>^"nameless" lambda . lambda . lambda . lambda . med 3 med 1 med (2 med 0 med 1) \
    "fix" := lambda f . (lambda x . med f med (lambda y . med (x med x ) med y)) med (lambda x . med f (lambda y . med (x med x ) med y)) &==>^"nameless" lambda . (lambda . 1 med (lambda . med (1 med 1) med 0)) med (lambda . med 1 med (lambda . med (1 med 1) med 0))
  $

  6.14
  $
    #`remove` _(Gamma) & (#`t`) := \
                     | & #`x`               && => #raw("index") _Gamma (#`x`) \
                     | & lambda #`x` . #`t` && => lambda . #`remove` _(#`x ::` Gamma) (#`t`) \
                     | & #`t1 t2`           && => #`remove` _Gamma (#`t1`) med #`remove` _Gamma (#`t2`) \
  $

  $"newname" := "choose the ﬁrst variable name that is not already in dom(Γ)."$
  $
    #`restore` _Gamma & (#`t`) := \
                    | & #`i`          && => Gamma#`[i]` \
                    | & lambda . #`t` && => lambda #`newname` _("dom"(Gamma)) . #`restore` _Gamma (#`t`) \
                    | & #`t1 t2`      && => #`restore` _Gamma (#`t1`) med #`restore` _Gamma (#`t2`)
  $

  6.2.2
  $
               attach(arrow.t, tr: 2) (λ.λ. med 1 med (0 med 2)) & = lambda . lambda med 1 med (0 med 4) \
    attach(↑, tr: 2) (λ. med 0 med 1 med (λ. med 0 med 1 med 2)) & = lambda . med 0 med 3 med (lambda. med 0 med 1 med 4)
  $
]

#let shift(x, y, t) = $med attach(arrow.t, tr: #x, br: #y)(#t)$
#definition("shifting")[

  The d-palce shift of a term t above cutoff c, written $shift(d, c, t)$, is defined as follows:

  $
              shift(d, c, k) & = cases(
                                 k \, k < c,
                                 k + d \, k >= c
                               ) \
     shift(d, c, lambda . t) & = lambda . shift(d, c + 1, t) \
    shift(d, c, t_1 med t_2) & = shift(d, c, t_1) med shift(d, c, t_2)
  $

  We write $shift(d, , t) "for" shift(d, 0, t)$.

]


#definition("substitution")[
  The substitution of a term $s$ for variable number $j$ in a term $t$,
  written $[j ↦ s]t$, is defined as follows:

  $
                [j ↦ s]k & = cases(
                             s\, k = j,
                             k\, "otherwise"
                           ) \
     [j ↦ s](λ. med t_1) & = λ. med [j+1 ↦ ↑¹(s)]t_1 \
    [j ↦ s](t_1 med t_2) & = ([j ↦ s]t_1 med [j ↦ s]t_2) \
  $

  when evaluate the application $(lambda . M) med v$, the substitution has little different, is defined as follows:
  $
    (lambda . M) med v = shift(-1, , [ 0 ↦ shift(1, , v) ] M)
  $
]
