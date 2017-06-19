# Subtyping in selection sets

The case of subtyping for selection sets is interesting.

A term $$\mathbf{m}(x: \mathbf{name}.\mathit{"Asia"} )$$ has a type that is a subtype of several types. For example, it matches

* $$\bot$$,
* $$\mathbf{m}(x: \mathit{Person} )$$,
* $$\mathbf{m}(x: \mathit{Place} )$$,
* $$\mathbf{m}(x: \mathit{Woman} )$$.

Hence, if out schema is something like $$\mathbf{m}(x: \mathit{Person} ), \mathbf{m}(x: \mathit{Place} )$$, the term can be proved to match the schema by more distinct derivation trees.

In general, the matching pair determines the execution rule to apply. Hence, if there are several matches, the execution is not deterministic.

At a first trial, we could take the _best_ match; so we can exclude $$\bot$$ for obvious reasons and $$\mathit{Woman}$$ because it is too specific (is that a good reason?).  But, we are left with $$\mathit{Place}$$ and $$\mathit{Person}$$ which are both good candidates.

We could accept all these options and perform an evaluation step for each of them at the same time. Or we could apply several other strategies.

In general, the _best_ strategy does not seem to exist. Hence, for now, we sweep the dust under the rug, saying that we are not concerned with this stuff: the ambiguity must be resolved by the programmer at design time. In other words, we do not allow schemas as above.

On the contrary, more query subterms could match the same schema subtype. For example,

* $$[ \cdot ]$$,
* $$\mathbf{m}(x: 1)$$,
* $$\mathbf{m}(x: 2)$$.

If we relax the GraphQL restriction that hole is applicable only to scalars, let us assume the schema type is $$m.( n.\mathit{Nat}))$$ with $$\rho_m = (n.4,l.3)$$, we could have queries like this:

$$
m.([\cdot], n.[\cdot])
$$

Where the result is

$$
m.( (n.4,l.3) , n.4 )
$$

It could be fun if we extend the language with recursion, too.
