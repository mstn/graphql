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

Hence, it is applicable to the schema defined in [our master example](./full-example.md). The evaluation of the query produces this value:

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
        $$ u: \bot $$
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

On the contrary the only query matching $$\top$$ is $$[\cdot]$$. The execution of $$\top, v \vdash [\cdot]$$ gives $$v$$ since $$v: \top$$. Intuitively, if we already know $$v$$, we cannot refine further our knowledge if the information about the datasource is the most generic.

The same kind of reasoning can be followed for nested $$\bot$$ and $$\top$$ types. For example, this schema

$$
\mathbf{user}(\mathbf{id}: \mathit{Nat}).\bot
$$

matches any query $$\mathbf{user}(\mathbf{id}: 1).t$$ and the execution results in values $$\mathbf{user}_{(\mathbf{id}: 1)}.0$$

### $$\rho$$ returns the empty value

Let us assume that $$\rho_{\mathbf{user}}(0, \mathbf{id}:1) = 0$$, that is, no user with id $$1$$ exists. This could lead to trouble during the execution because, for example, the projection on $$\mathbf{name}$$ is not defined on the empty value!

Probably, the easiest solution in this case is to introduce a special rule for fields explicitly. If the result of a resolver is $$0$$, then the execution is terminated immediately. In this case, we get $$\mathbf{user}_{(\mathbf{id}: 1)}.0$$ as result.

The resulting value type is a subtype of the query type.
