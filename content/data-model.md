# Data model

We use labelled directed pointed graphs to represent datasources.
A graph can denote the database we interrogate as well as the result of the execution of a query.

The tree-like structure of directed graphs is not intended to model just document-oriented or graph-based databases. Directed graphs represent the relations between different entities more than the actual representation of raw data as classical flat SQL tuples or MongoDB documents. For example, the relation "has a best friend" between two movie characters is naturally represented with a directed edge, but the actual implementation could be two rows joined by a foreign key in an SQL table or a nested object in MongoDB.

In next sections we consider also the case where the execution of a query yields an infinite result.

The set of labelled directed graphs is denoted as $$\mathcal{G}$$ and it is defined by induction as follows:

$$ G = 0 \;|\; v \;|\; \{ m_i:G \}_{i=1 \ldots n} $$

A graph is empty $$0$$, or a base value $$v$$ (e.g. a string, a number) or is a node object with $$n$$ out-going $$m_i$$ labeled edges pointing to $$n$$ graphs. Out-going labels must be distinct.

In a similar way to Javascript arrays, we define finite sets of graphs in terms of objects where label names are ignored. For example, the set $$\{G_1, G_2\}$$ is represented as a node object $$\{1:G_1, 2:G_2\}$$ (i.e. it is a multiset); since it is a set and not a list, labels are "unordered", that is, their names are not relevant as far as the uniqueness constraint is satisfied.

We write $$m_i.G_i \in G$$, if $$G$$ is a graph defined as $$\{ m_1:G_1, \ldots , m_i:G_i, \ldots , m_n:G_n \}$$.

A projection operation $$\pi_{m_i}$$ on a graph $$G$$ is a partial function defined as $$\pi_{m_i}(G)=G'$$ if $$m_i.G' \in G$$, $$\bot$$ otherwise.

The idea of representing semistructured data in a similar way in the context of query languages is not new at all. For example, consider {{ "cardelli02" | cite }} (i.e. infotrees or multisets), {{ "sazanov09" | cite}} (i.e. hypersets) and many other references can be found in the literature.

The clever reader should have noticed that our graphs are actually finite trees. We prefer to use the term graph since the beginning because, sooner or later, we will introduce finite and infinite directed graphs in our data model.
