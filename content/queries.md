# Queries

$$Q = \{ m_i(\overline{x}:\overline{d}):Q_i \}_{i=1 \ldots n} \;|\; 0$$

Queries are defined inductively as above.

Intuitively, a query $$m_i(\overline{x}:\overline{d}).Q_i$$ is a sort of procedure call $$m_i$$ on a given dataset and returns a graph with a compatible structure. $$0$$ is the empty query whose result is the emptyset.

For clarity, we often omit $$0$$ and $$(\overline{x}:\overline{d})$$ when there are no arguments.

Queries can also change the original dataset. GraphQL calls these queries mutations. We will study mutations in next sections. Since we do not have multiple types of queries at the moment, we do not need **query** and **mutation** keywords to distinguish between read-only and write queries, respectively. Hence, our query definition corresponds to GraphQL shorthand for unnamed query operations.

GraphQL has a more complex syntax. Queries are organized in query documents and can be parametrized and have a name. Here, we are considering the shorthand syntax of GraphQL. We will study more advanced systax in what follows.

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
