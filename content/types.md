# Types

$$\tau = \bot \;|\; \mathit{Int},\mathit{String}, \ldots \;|\; \{m_i(\overline{x}:\overline{\tau}):\tau_i\}_{i=1 \ldots n} \;|\; [ \tau ]$$

Types are defined by the inductive definition above. We include $$\bot$$ which is not present in the original spec: it is the type corresponding to an empty query.

Scalar types are basic types such as integers, strings and so forth.

Object types are defined as $$\{m_i(\overline{x}:\overline{\tau}):\tau_i\}$$ where $$m_i$$ are names and $$\overline{x}$$ and $$\overline{\tau}$$ vectors of variables and types, respectively. We assume that a function $$\rho_{m_i}$$ exists for each $$m_i$$ called the _resolve function_ for $$m_i$$. The signature of $$\rho_{m_i}$$ is $$\mathcal{G} \times \Pi_{\tau \in \overline{\tau}} \mathcal{G}_{\tau} \to \mathcal{G}:\tau_i$$ where $$\mathcal{G}$$ is the set of pointed directed graphs and $$\mathcal{G}_{\tau}$$ is the set of graphs of type $$\tau$$. For simplicity's sake, we often omit arguments if no argument is required.

In plain English, a resolve function takes as input a directed graph and a list of parameters and returns another directed graph of type $$\tau_i$$. Intuitively, this is the execution semantics of a query. GraphQL is independent from the underlying database. For this reason, we do not specify how $$\rho_{m_i}$$ is implemented. For scalar types, $$\rho_{m_i}$$ is often defined as a projection function $$\pi_{m_i}$$ such that $$\pi_{m_i} \{m_i:G_i\}_i = G_i$$ where $$\{m_i:G_i\}_i$$ is a directed graph.

Finally, $$[ \tau ]$$ is a type for a list of object of type $$\tau$$.

A database schema is defined by a root type we denote as $$\mathit{Root}$$.

It might seem odd that we include a resolve function in type definitions. However, types can be interpreted _extensionally_ as the sets of elements with a given property. In formal languages the extension of a type is implicit in the structure of a type. On the contrary, here, the extension is given explicitly since it depends on the underlying implementation and not on the abstract semantics of our simplified GraphQL.

A query $$Q$$ matches a schema type $$\mathit{Root}$$ (notation $$Q:\mathit{Root}$$) when:

* $$0:\bot$$;
* if, for $$i=1 \ldots n$$, $$m_i(\overline{y}:\overline{\tau}):\tau_i \in \mathit{Root}$$, $$Q_i:\tau_i$$ and $$\overline{d}:\overline{\tau}$$, $$\{ m_i(\overline{x}:\overline{d}).Q_i \}_{i=1 \ldots n}: \mathit{Root}$$.

### Example (cont'd)

The database is given by the following SQL-like tables with nested rows.

**Humans**

| id | name | friends | appearsIn | homePlanet |
| -- | -- | -- | -- | -- |
| 1000 | Luke Skywalker  | 1002, 1003, 2000, 2001 | 4, 5, 6 | Tatooine |
| 1001 | Darth Vader     | 1004 | 4, 5, 6 | Tatooine |
| 1002 | Han Solo  | 1000, 1003, 2001 | 4, 5, 6 | - |
| 1003 | Leia Organa  | 1000, 1002, 2000, 2001 | 4, 5, 6 | Alderaan |
| 1004 | Wilhuff Tarkin  | 1001 | 4 | - |

**Droids**

| id | name | friends | appearsIn | primaryFunction |
| -- | -- | -- | -- | -- |
| 2000 | C-3PO  | 1000, 1001, 1003, 2001 | 4, 5, 6 | Protocol |
| 2001 | C2-D2  | 1000, 1002, 1003 | 4, 5, 6 | Astromech |

We abstract away from this particular implementation defining a type system as follows.

$$\begin{array}{lll}

  \mathit{Human} &=& \{ \\
    && \quad \mathbf{id}:\mathit{String}, \\
    && \quad \mathbf{name}:\mathit{String}, \\
    && \quad \mathbf{friends}:[\mathit{Character}], \\
    && \quad \mathbf{appearsIn}:[\mathit{Episode}], \\
    && \quad \mathbf{homePlanet}: \mathit{String} \\
    && \} \\

  \mathit{Droid} &=& \{ \\
    && \quad \mathbf{id}:\mathit{String}, \\
    && \quad \mathbf{name}:\mathit{String}, \\
    && \quad \mathbf{friends}:[\mathit{Character}], \\
    && \quad \mathbf{appearsIn}:[\mathit{Episode}], \\
    && \quad \mathbf{primaryFunction}: \mathit{String} \\
    && \} \\

  \mathit{Character} &=& \{ \\
    && \quad \mathbf{id}:\mathit{String}, \\
    && \quad \mathbf{name}:\mathit{String}, \\
    && \quad \mathbf{friends}:[\mathit{Character}], \\
    && \quad \mathbf{appearsIn}:[\mathit{Episode}] \\
    && \} \\

  \mathit{Episode} &=& \mathit{Integer} \\

  \mathit{Root} &=& \{ \mathbf{hero}(e: \mathit{Episode}):\mathit{Character} \}

\end{array}$$

By convention, $$\mathit{Root}$$ is the entry point of our database schema.

For scalar types, the resolve function is a projection as defined above. We still need to define a resolve function for $$\mathbf{friends}$$ and  $$\mathbf{hero}$$. The pseudo code below is a simplified version of the Facebook example.

     function friends(root, params){
       function findCharacter(id){
         return  findSQL(Humans, {id:id}) || findSQL(Droids, {id:id});
       }
       root.map( id => findCharacter(id) );
     }

     function hero(root, params){
       var episode = params.episode;
       switch(episode){
         case 5:
          // return Luke
          return findOneSQL(Humans, {id:1000});
         default:
          // otherwise
          return findOneSQL(Droids, {id:2001});
       }
     }
