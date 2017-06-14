# Schema

A schema $$\Sigma$$ is a pair $$(\Sigma_T, \Sigma_\rho)$$ where $$\Sigma_T$$ is a type and  $$\Sigma_\rho$$ is a set of resolver functions indexed by field name.

The execution of a query $$q$$ against a datasource makes sense if it matches the schema type $$T$$ of the datasource. Since the type of a query is not unique due to subtyping rules, we require that the minimum type is the matching type.

Formally, we say that $$q$$ matches $$T$$ (notation: $$q \downarrow T$$ if $$T \leq T'$$ where $$q: T'$$ and, for every $$U$$ such that $$q:U$$, $$T' \leq U$$.

> We need to define $$\downarrow$$ with minimization because every term has type $$\top$$. The culprit is the T-SUB rule. We could get rid of of this rule quite easily, but we prefer to keep it because it is found in the literature.

The result of the execution of a query against a matching schema is a value (see next section). The type of the result is a subtype of the query as well as the schema.
