# Subtyping in sets

The case of subtyping for sets is interesting. Our working rule is quite restrictive since it requires the existence of a unique matching between subterms.

<table class="deduction-tree">
    <tr>
        <td>
         $$\forall i=1 \ldots m \exists ! j \in 1 \ldots n$$ such that $$T_{j} \leq U_i$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ (T^{i=1 \ldots n}) \leq (U^{i=1 \ldots m}) $$
    </td></tr>
</table>

The reason is that a term $$\mathbf{m}(x: \mathbf{name}.\mathit{"Asia"} )$$ has a type that could match more types in the schema. For example,

* $$\bot$$,
* $$\mathbf{m}(x: \mathit{Person} )$$,
* $$\mathbf{m}(x: \mathit{Place} )$$,
* $$\mathbf{m}(x: \mathit{Woman} )$$.

At a first trial, we could take the _best_ match; so we can exclude $$\bot$$ for obvious reasons and $$\mathit{Woman}$$ because it is too specific (is that a good reason?).  But, we are left with $$\mathit{Place}$$ and $$\mathit{Person}$$ which are both good candidates.

We could accept all these options and perform an evaluation step for each of them. Or we could apply several other strategies.

In general, the _best_ strategy does not seem to exist. Hence, for now, we sweep the dust under the rug, saying that we are not concerned with this stuff: the ambiguity must be resolved by the programmer at design time.

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
