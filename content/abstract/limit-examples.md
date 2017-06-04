# Limit cases

Here, I collect a set of limit cases in order to test the robustness of the language. They could be useful as exercises for learning the semantics, but I do not think they have any utility in practice.

### Scalar values in queries

The following query

$$
\mathbf{user}(\mathbf{id}: 1).\mathbf{name}.\mathit{"dummy"}
$$

has type

$$
\mathbf{user}(\mathbf{id}: \mathit{Nat}).\mathbf{name}.\mathit{String}
$$

Hence, it is applicable to the schema defined in [our master example](./examples.md). The evaluation of the query produces this value:

$$
\mathbf{user}_{(\mathbf{id}: 1)}.\mathbf{name}.\mathit{"dummy"}
$$

Instead of the hole rule, we apply the context skip rule and we ignore the result of the query in the selection set.

The case of a query made of a scalar value, say $$42$$, is legit. Those queries can be executed on the $$\bot$$ or the $$\mathit{Nat}$$ schemas. In the former case, $$0$$ is returned, while in the latter, no execution rule can be applied and it is ok, since a scalar is already a value. My only concern is that, since $$42$$ is a value, it should be in normal form. Not a big issue in practice because this is a very limit case.

### Queries and DoS

Since $$[\cdot]: \top$$, it can be executed against any schema $$T$$. However, $$[\cdot]$$ cannot be exploited by hackers for DoS attacks (e.g. query all the dataset). In fact, it will always return the root value, that is, usually $$0$$. This makes sense with the intuition behind the hole construct. Hole is a way to peep the current state of the execution. If no actual query has been performed, we do not have any data.

### $$\top$$ and $$\bot$$ schemas

Schema $$\bot$$ matches any query. The result of the execution of any query against $$\bot$$ is $$0$$. If the query is $$[\cdot]$$, we can apply two rules, namely, the box and the empty rule. In general, this is not a problem as far as the result is the same. The condition on the hole rule comes in our help.

<table class="deduction-tree">
    <tr>
        <td>
        $$ u \leq \bot $$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \bot, u \vdash [\cdot] \to u $$
    </td></tr>
</table>

Indeed, the only possible value for $$u$$ is $$0$$. If it is not, only the null rule is applicable.

On the contrary the only query matching $$\top$$ is $$[\cdot]$$. The execution of $$\top, v \vdash [\cdot]$$ gives $$v$$ since $$v \leq \top$$. Intuitively, if we already know $$v$$, we cannot refine further our knowledge if the information about the datasource is the most generic.

The same kind of reasoning can be followed for nested $$\bot$$ and $$\top$$ types. For example, this schema

$$
\mathbf{user}(\mathbf{id}: \mathit{Nat}).\bot
$$

matches any query $$\mathbf{user}(\mathbf{id}: 1).t$$ and the execution results in values $$\mathbf{user}_{(\mathbf{id}: 1)}.0$$

### $$\rho$$ returns the empty value

Let us assume that $$\rho_{\mathbf{user}}(0, \mathbf{id}:1) = 0$$, that is, no user with id $$1$$ exists. This could lead to trouble during the execution because, for example, the projection on $$\mathbf{name}$$ is not defined on the empty value!

Probably, the easiest solution in this case is to introduce a special rule for fields explicitly. If the result of a resolver is $$0$$, then the execution is terminated immediately. In this case, we get $$\mathbf{user}_{(\mathbf{id}: 1)}.0$$ as result.

The resulting value type is a subtype of the query type.

### Sets

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

## Argument evaluation

Arguments are restricted to be values. This is inline with GraphQL rules. However, the reason is that terms as arguments could be problematic. For example, consider a possible evaluation rule.

<table class="deduction-tree">
    <tr>
        <td>
          $$\Sigma, u \vdash t_{1} \to t'_{1}$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash m(x: t_{1}).t_{2} \to m(x: t'_{1}).t_{2} $$
    </td></tr>
</table>

The rule is applied with respect to a context $$\Sigma, u$$. But $$t_1$$ must be evaluated on the root schema. In addition, it is not clear which should be its context, probably not $$u$$. Hence, for now, we omit this case and we keep it simple.

## Fragments

Let us assume that $$\mathit{User}$$ is a subtype of $$\mathit{Person}$$.

* $$\mathit{User} = (\mathbf{name}.\mathit{String},\mathbf{lastLogin}.\mathit{Int})$$,
* $$\mathit{Person} = (\mathbf{name}.\mathit{String})$$

$$\mathit{User}, u \vdash \langle \mathit{Person} \rangle.\mathbf{name} \to \mathit{Person}, u \triangleright \mathbf{name}$$ is a sort of upcasting. Since $$u: \mathit{User}$$, we can infer $$u: \mathit{Person}$$, too.

$$\mathit{Person}, u \vdash \langle \mathit{User} \rangle.(\mathbf{name}, \mathbf{lastLogin}) $$ has two possible derivations. If $$u$$ is not $$\mathit{User}$$, then we get $$0$$. Otherwise,  $$\mathit{User}, u \triangleright (\mathbf{name}, \mathbf{lastLogin})$$. The second case is a "safe" downcasting. It is safe because at run time we know for sure that $$u$$ is $$\mathit{User}$$.

In general, fragments are applied to any schema, but well-typed fragments require that $$T \leq T'$$ and $$\Gamma \vdash t: T'$$. This condition is needed to guarantee that the subterm is evaluable in the new context.

For example, in the first case, $$\mathit{Person} \leq \mathbf{name}.\top$$ and $$t: \mathbf{name}.\top$$. On the contrary, $$\langle \mathit{Person} \rangle.(\mathbf{name}, \mathbf{lastLogin})$$ would not have been well-typed since $$\mathbf{lastLogin}$$ is not a field in $$\mathit{Person}$$.

As in the real GraphQL, we can also have queries like this

$$ \langle \mathit{Person} \rangle.\langle \mathit{User} \rangle.(\mathbf{name}, \mathbf{lastLogin})$$

This query is well-typed as the following derivation tree proves.

<table class="deduction-tree">
    <tr>
        <td>
          <table class="deduction-tree">
              <tr>
                  <td>
                    <table class="deduction-tree">
                        <tr>
                            <td>
                              ...
                            </td>
                            <td class="rulename" rowspan="2">
                              <div class="rulename"></div>
                            </td>
                        </tr>
                        <tr><td class="conc">
                          $$ (\mathbf{name}, \mathbf{lastLogin}): (\mathbf{name}.\top, \mathbf{lastLogin}.\top) $$
                        </td></tr>
                    </table>
                  </td>
                  <td>
                    <table class="deduction-tree">
                        <tr>
                            <td>
                              ...
                            </td>
                            <td class="rulename" rowspan="2">
                              <div class="rulename"></div>
                            </td>
                        </tr>
                        <tr><td class="conc">
                          $$ \mathit{User} \leq (\mathbf{name}.\top, \mathbf{lastLogin}.\top) $$
                        </td></tr>
                    </table>
                  </td>
                  <td class="rulename" rowspan="2">
                    <div class="rulename"></div>
                  </td>
              </tr>
              <tr><td class="conc" colspan="2">
                $$ \langle \mathit{User} \rangle.(\mathbf{name}, \mathbf{lastLogin}): \top $$
              </td></tr>
          </table>
        </td>
        <td>
          <table class="deduction-tree">
              <tr>
                  <td>
                  </td>
                  <td class="rulename" rowspan="2">
                    <div class="rulename"></div>
                  </td>
              </tr>
              <tr><td class="conc">
                $$ \mathit{Person} \leq \top $$
              </td></tr>
          </table>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc" colspan="2">
      $$ \langle \mathit{Person} \rangle.\langle \mathit{User} \rangle.(\mathbf{name}, \mathbf{lastLogin}): \top $$
    </td></tr>
</table>

Since $$\mathit{Person}$$ has a $$\mathbf{name}$$ field, we could also write,

$$ \langle \mathit{Person} \rangle.(\mathbf{name}, \langle \mathit{User} \rangle.\mathbf{lastLogin})$$

that is well-typed, too.

Let's see the case with disjoint unions. Consider these two types:

* $$\mathit{Cat} = \{ \mathbf{name}.\mathit{String}, \mathbf{meow}.\mathit{Bool}\}$$,
* $$\mathit{Dog} = \{ \mathbf{name}.\mathit{String}, \mathbf{bark}.\mathit{Bool}\}$$

On the contrary of the previous case,

$$\langle \mathit{Cat}+\mathit{Dog} \rangle. \mathbf{name}$$

is not well typed. Indeed, a term of type $$\mathit{Cat}+\mathit{Dog}$$ has form $$\mathit{inl}\, t$$ or $$\mathit{inr}\, t$$ and does not have a field $$\mathbf{name}$$. Note that we cannot have queries like this neither in the real GraphQL. With non-disjoint union it would be different, since $$\mathbf{name}$$ property is in the intersection of $$\mathit{Cat}$$ and $$\mathit{Dog}$$.

Now, in order to get a well-typed query, we need to project union terms to a simple object term.

$$\langle \mathit{Cat}+\mathit{Dog} \rangle. \langle \mathit{Cat} \rangle.  \mathbf{name}$$

The query is well typed.

<table class="deduction-tree">
    <tr>
        <td>
          <table class="deduction-tree">
              <tr>
                  <td>
                    <table class="deduction-tree">
                        <tr>
                            <td>
                              ...
                            </td>
                            <td class="rulename" rowspan="2">
                              <div class="rulename"></div>
                            </td>
                        </tr>
                        <tr><td class="conc">
                          $$ \mathbf{name} : \mathbf{name}.\top $$
                        </td></tr>
                    </table>
                  </td>
                  <td>
                    <table class="deduction-tree">
                        <tr>
                            <td>
                              ...
                            </td>
                            <td class="rulename" rowspan="2">
                              <div class="rulename"></div>
                            </td>
                        </tr>
                        <tr><td class="conc">
                          $$ \mathit{Cat} \leq \mathbf{name}.\top $$
                        </td></tr>
                    </table>
                  </td>                  
                  <td class="rulename" rowspan="2">
                    <div class="rulename"></div>
                  </td>
              </tr>
              <tr><td class="conc" colspan="2">
                $$ \langle \mathit{Cat} \rangle.\mathbf{name}: \top $$
              </td></tr>
          </table>
        </td>
        <td>
          <table class="deduction-tree">
              <tr>
                  <td>
                  </td>
                  <td class="rulename" rowspan="2">
                    <div class="rulename"></div>
                  </td>
              </tr>
              <tr><td class="conc">
                $$ \mathit{Cat} + \mathit{Dog} \leq \top $$
              </td></tr>
          </table>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc" colspan="2">
      $$ \langle \mathit{Cat} + \mathit{Dog} \rangle.\langle \mathit{Cat} \rangle.\mathbf{name}: \top $$
    </td></tr>
</table>

## Unions as inputs

GraphQL has a different type for object inputs, i.e. _InputObjectType_. In particular it is not possible to define an input whose type is the union of several types. The reason is that the resolver function would not be able to discriminate the type of input arguments.

However, in our case, inputs can be unions. The fact that union is disjoint allows us to know always which is the type of the object in input.

Consider this schema type.

$$ \mathbf{cuddle}(\mathbf{pet}: \mathit{Cat} + \mathit{Dog}).\mathit{Bool}$$

It takes a pet and returns $$\mathit{true}$$ if the pet is happy with our cuddling, $$\mathit{false}$$ otherwise. It is well-known that dogs prefer to be cuddled near the tail while cats want to be scratched under the neck. Hence, the resolver for $$\mathbf{cuddle}$$ must know which cuddling mode is more appropriate.

The resolver function can be implemented in this way:

```js
function cuddle(root: void, pet: Cat + Dog) {
  switch(pet) {
    case intl(cat):
      return scratch(cat);
    case intr(dog):
      return caress(dog);
  }
}
```

GraphQL output types can be already unions of types. As we discussed previously, output union types are basically disjoint unions. Two user-defined functions, i.e. `resolveType` and `isTypeOf`, play a role similar to `intl` and `intr` constructors in our example. The resolve function could retrieve the type of arguments with simple tests like `Cat.isTypeOf(pet)`. Alternatively, a resolver could be a function, as it is now, or a map from type names to resolve functions.
