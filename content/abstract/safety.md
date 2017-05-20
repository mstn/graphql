# Safety

Safety is a property that sounds like a Bob Marley's song. Roughly, it says that, if a term is well-typed, everything is gonna be alright. In programming languages, bad things happen if the evaluation of a term gets stuck.

In our case, we want to be sure that, if a query matches a schema, we will see a resulting value sooner or later. Note that a query is always well-typed (i.e. we can assign a type to it), but, here, we are saying also that the schema type must be a subtype of the query type.

More formally, a term $$t$$ matches a schema $$\Sigma=(T,\rho)$$ if $$t: T' \wedge T \leq T'$$ and we write $$T \leq t$$.

In the rest of this section we are following {{ "pierce02" | cite}} where safety is defined as progress plus preservation.

**Proposition (progress).** Given a schema $$\Sigma=(T,\rho)$$, if $$T \leq t$$, then $$t=v$$ for some value $$v$$ or there exists $$t'$$ such that $$t \to t'$$.

**Proposition (preservation).** Given a schema $$\Sigma=(T,\rho)$$, if $$T \leq t$$ and $$t \to t'$$, then $$T \leq t'$$.
