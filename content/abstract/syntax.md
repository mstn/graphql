# Syntax

Queries are terms whose execution against a schema yields a value. Terms and value are basically trees.
The idea of representing semistructured data as trees in the context of query languages is not new at all. For example, consider {{ "cardelli02" | cite }} (i.e. infotrees or multisets), {{ "sazanov09" | cite}} (i.e. hypersets) and many other references can be found in the literature.

## Types

Types are defined by the inductive definition above.

$$
\begin{aligned}
t &=& \bot                                     \\
  & & \top                                    \\
  & & \mathit{Nat}                             \\
  & & \mathit{Bool}                           \\
  & & \mathit{String}                           \\
  & & m( x: T \ldots).T                    \\
  & & T,T \\
  & & T + T \\
  & & x
\end{aligned}
$$

We include $$\bot$$ and $$\top$$ which are not present in the original spec. Intuitively, they are the types for the _empty_ query and the _any_ query, respectively. They will turn out to be useful in the definition of the execution semantics.

Scalar types are basic types such as integers, strings and so forth. In our examples, we will consider mainly $$\mathit{Nat}$$, $$\mathit{Bool}$$ and $$\mathit{String}$$.

A field is $$m( x: T \ldots).T' $$. We assume that a function $$\rho_{m}$$ exists for each label name $$m$$ called the _resolve function_ for $$m$$. The signature of $$\rho_{m}$$ is $$v \times \Pi_{x:T} v_{T} \to v$$ where $$v$$ is the set of values and $$v_T$$ is the set of values of type $$T$$.

Intuitively, the resolve function is the execution semantics of a query. GraphQL is independent from the underlying database. For this reason, we do not specify how $$\rho_{m}$$ is implemented. For scalar types, $$\rho_{m}$$ is often defined as a projection function $$\pi_{m}$$.

In addition, the first input (i.e. root) and the output of a resolver are not constrained to match a pre-defined type. The reason is that the format of the result of a resolver is considered an internal detail and it is not controlled by the abstract language.

$$T+T$$ is the sum type (aka disjoint union). I am assuming that GraphQL union is actually a disjoint union. As far I know, there is no claim about the kind of union, but there are some hints from the reference implementation.
* Union type is required to provide _resolveType_ function or the two addends must define _isTypeOf_ function. This is a sort of "tag" on values.
* If a value has both the addends as type (i.e. isTypeOf is true), only one is taken.
* On the contrary of interfaces, fragments are required when output is a union. If union were not disjoint, the type system could infer the fields in the intersection of the field sets of the two addends.

Hence, we model GraphQL union as a disjoint union following {{ "pierce02" | cite}} as usual. In passing, it would be interesting to implement a non disjoint union as a possible extension of the language.

$$T,T$$ is a finite set of types. We use parenthesis to resolve ambiguities, e.g. $$\mathbf{m}.(T_1,T_2),T_3$$.

Finally, $$x$$ is a type variable. As usual, typing rules will be defined in a context $$\Gamma$$ where variable names are resolved to a type.

## Terms and values

Terms are defined by the following rules.

$$
\begin{aligned}
t &=& 0                                     \\
  & & \mathbf{n}                             \\
  & & \mathbf{s}                             \\
  & & \mathbf{true}                           \\
  & & \mathbf{false} \\
  & & \mathbf{err} \\
  & & [ \cdot ]  \\
  & & m( x: v \ldots).t                      \\
  & & m_{( x: v \ldots)}.t                      \\
  & & \langle T \rangle.t                    \\
  & & \Sigma, v \triangleright t                \\
  & & t,t                  \\
  & & \mathit{inl} \, t \\
  & & \mathit{inr} \, t \\
\end{aligned}
$$

Values are a subset of terms defined as below.

$$
\begin{aligned}
v &=& 0                                     \\
  & & \mathbf{n}                             \\
  & & \mathbf{s}   \\
  & & \mathbf{true}     \\
  & & \mathbf{false} \\
  & & \mathbf{err} \\
  & & m_{( x: v \ldots)}.v                      \\
  & & v,v \\
  & & \mathit{inl} \, v \\
  & & \mathit{inr} \, v \\
\end{aligned}
$$

Intuitively, terms corresponds to queries while values to the result of the execution of queries against a schema.

$$0$$ is the empty query whose result is the emptyset. Then, $$\mathbf{n}$$ for each $$n \in \mathbb{N}$$, $$\mathbf{s}$$ for each string $$s$$, $$\mathbf{true}$$ and $$\mathbf{false}$$ are scalar values.

Hole $$[ \cdot ]$$ is a term with a hole in it. The function of a hole is to capture the current root value during evaluation. Its role will be clear when we discuss the operational semantics of the language.

A field $$m(x:t).t'$$ is a sort of procedure call $$m$$ on a given dataset and returns a value with a compatible structure. If $$t'$$ is a hole $$[\cdot]$$ we write $$m( x: t \ldots)$$ instead of $$m( x: t \ldots).[\cdot]$$.

We distinguish fields from already executed fields. If $$m(x:t).t'$$ is a field, then after execution is denoted $$m_{(x:v)}.t'$$. The reason is technical. Since we want values to be normal terms (i.e. no execution step can be applied), we need to distinguish the two cases. In addition, we keep the information on the value of the parameters at execution time, because we can have multiple calls to a field with different arguments in the same query. In the real world, GraphQL does not allow this kind of queries because the current implementation does not keep argument values in the computed result. Hence, the execution of the same field on different values leads to ambiguous selection sets. We made a different choice which is similar to the internal state representation of Apollo client.

Inline fragments are denoted as $$\langle T \rangle.t$$. Roughly speaking, $$T$$ is the type condition and $$t$$ the selection set.

Context $$\Sigma, v \triangleright t$$ is a term that propagates a new context through a term $$t$$. In other words, $$\Sigma, v$$ becomes the new context to use for the evaluation of term $$t$$.

Finally, $$v,v$$ are simply finite set of terms. In GraphQL terminology they correspond to selection sets. As for types, we use parenthesis to resolve ambiguities, e.g. $$\mathbf{m}.(v_1,v_2),v_3$$.


### Example

We consider the usual [Star Wars](https://github.com/graphql/graphql-js/blob/master/src/__tests__/starWarsSchema.js) example proposed by Facebook with some simplifications.

A query to fetch the hero for an episode is defined as:

$$\begin{array}{l}
\{ \\
  \quad \mathbf{hero}(\mathit{episode}:5): \{ \\
    \quad \quad \mathbf{name}  \\
  \quad  \} \\
\}
\end{array}$$

And the result is a tree with the same structure as the query:

$$\begin{array}{l}
\{ \\
  \quad \mathbf{hero}: \{ \\
    \quad \quad \mathbf{name}: \mathit{"Luke \; Skywalker"} \\
  \quad  \} \\
\}
\end{array}$$

The abstract syntax for the query is a term

$$
  \mathbf{hero}(\mathit{episode}:5).\mathbf{name}.[\cdot]
$$

While the result corresponds to a value

$$
  \mathbf{hero}_{(\mathit{episode}:5)}.\mathbf{name}.\mathit{"Luke \; Skywalker"}
$$

## Schema

A schema $$\Sigma$$ is a pair $$(T, \rho)$$ where $$T$$ is a type and $$\rho$$ is a resolve function for each label name in $$T$$.

### Example (cont'd)

The database is given by the following SQL-like tables with nested rows.

**Humans**

| id | name | bestie |  homePlanet |
| -- | -- | -- | -- | -- |
| 1000 | Luke Skywalker  | 1002  | Tatooine |
| 1001 | Darth Vader     | 1004  | Tatooine |
| 1002 | Han Solo  | 1000  | - |
| 1003 | Leia Organa  | 1000 | Alderaan |
| 1004 | Wilhuff Tarkin  | 1001  | - |

**Droids**

| id | name | bestie | primaryFunction |
| -- | -- | -- | -- | -- |
| 2000 | C-3PO  | 1000| Protocol |
| 2001 | C2-D2  | 1000 | Astromech |

We abstract away from this particular SQL-like implementation defining a schema $$\Sigma=(T, \rho)$$. The type $$T$$ is,

$$
\mathbf{hero}(e: \mathit{Nat}).\mathit{Human} + \mathit{Droid}
$$

Where $$\mathit{Human}$$ and $$\mathit{Droid}$$ are type variables,

$$\begin{array}{lll}

  \mathit{Human} &=& ( \\
    && \quad \mathbf{id}.\mathit{String} \\
    && \quad \mathbf{name}.\mathit{String} \\
    && \quad \mathbf{bestie}.\mathit{Human} + \mathit{Droid} \\
    && \quad \mathbf{homePlanet}.\mathit{String} \\
    && ) \\

  \mathit{Droid} &=& ( \\
    && \quad \mathbf{id}.\mathit{String} \\
    && \quad \mathbf{name}.\mathit{String} \\
    && \quad \mathbf{bestie}.\mathit{Human} + \mathit{Droid} \\
    && \quad \mathbf{primaryFunction}.\mathit{String} \\
    && ) \\

\end{array}$$

Now we define the resolve function $$\rho$$. For scalar types, the resolve function is a projection on the name of the field. Then, we need to define a resolve function for $$\mathbf{bestie}$$ and  $$\mathbf{hero}$$. The pseudo code below is a simplified version of the Facebook example.

```js
function bestie(root, params){
 function findCharacter(id){
   return  findOneSQL(Humans, {id:id}) || findOneSQL(Droids, {id:id});
 }
 return findCharacter(root.bestie);
}

function hero(root, params){
 var episode = params.e;
 switch(episode){
   case 5:
    // return Luke
    return findOneSQL(Humans, {id:1000});
   default:
    // otherwise
    return findOneSQL(Droids, {id:2001});
 }
}
```
