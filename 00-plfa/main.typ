#import "../setup/conf.typ": *
#import "../setup/theorem.typ": *

#show: thm-rules

#show: project.with(
  title: "plfa notes",
  title_page: true,
  compat_title_page: true,
)

= agda language

== Precedence
== currying

```haskell
ℕ → ℕ → ℕ := ℕ → (ℕ → ℕ)
```
