# The Big Plan

This project is an attempt to study GraphQL in the hard way, that is, building some abstract theoretical tools for reasoning about GraphQL and related architectures.

We want to share our struggles since the first commit in order to get early feedback and to verify if somebody is interested in contributing following this approach. _Please bear in mind that this is a very preliminary still unrevised work._

We do not think there is anything new from a theoretical point of view. We are going to apply results developed in the late 80s/90s about databases and query languages.

We do not want to keep our investigation too abstract. Indeed, we would like to give a contribution to GraphQL community in terms of concrete lines of code in a real world contest.

We do not want to scare readers with too mathematical language. We will try to keep it simple and informal. Nevertheless, some preliminary background is required. A good reference full of examples and solved exercises is {{ "pierce02" | cite}}. You can also find various lesson notes on the web for free about formal semantics of programming languages.

In the rest we discuss the tentative list of arguments we are going to tackle. The following points are not stable yet, it is pretty much wishful thinking and I could change my mind easily.

## Syntax and Semantics of GraphQL

As far I know, Facebook did not provide a formal specification of the language, execution semantics and type system. There is only a reference implementation {{ "graphql-ref-impl" | cite }} in Javascript and an informal spec document {{ "graphql-spec" | cite }}. The first step will be to define an abstract semantics for GraphQL independent from the particular technology.

* Expressiveness and possible extensions.
* GraphQL does not have recursion, e.g. get the list of friends of friends. Recursion can be problematic since it could yield infinite results, but it is very useful.
  * A common pattern in modern web applications is infinite scrolling. A recursive query could define infinite scrolling in a concise and explicit way. Hence, it makes sense to add a new directive to handle recursion.
  * GraphQL forbids any sort of self-reference because the problem of infinite loops. However, sometimes, only the unfolding of some relations is infinite, there could be a finite representation as a cyclic graph. E.g. A is friend of B and B is friend of A.
* Use of existing logical tools (e.g. {{ "cardelli02" | cite }}) to reason about queries
* ...

## Live queries and reactivity

GraphQL is a great tool, but it is still lacking some good reactive mechanisms. The aim of Apollo {{ "apollo" | cite}} is to bring together the GraphQL and reactivity following the experience matured with Meteor {{ "meteor" | cite }}.

* Live queries could be modeled as an infinite stream.
* Indirect dependencies and reactivity.
  * It is hard to build efficient reactive joins between different datasources.
  * Sometimes a datasource depends reactively on another. How can we make this dependency explicit?
* Counters.
* Pagination sucks.
* ...

## Caching

One of the most exciting features of Relay is the GraphQL cache on the client side. A smart cache generates a query to fetch just the missing data or to update only the staled parts.

* Query composition and decomposition wrt cached data.
* ...

## Reflection

GraphQL supports reflection. It could be interesting to understand how much we can get from reflection. Everything is a directed graph: results, queries, types. So, at least in principle, we can build queries not only on datasources, but on queries themselves and types. Cool!
