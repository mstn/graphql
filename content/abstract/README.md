# Introduction

In this section we consider a simplified syntax of GraphQL. Our goal is to define an abstract syntax that will allow us to study the properties of the language without worrying about its implementation details.

We make some assumptions on the language structure in order to simplify our work.

* We do not distinguish between queries and mutations. Mutations are queries with side effects, but, at the moment, we are not interested in a special syntax to mark mutations. We do not say that it is not important, but we will reserve this case study to future work.
* Queries are not represented as an operation name followed by a list of variables as in the official GraphQL specification. Variable definitions are not needed since they correspond to free variables in a query term.
* Root types can by any type, typically an object type. This allows us to avoid some ad hoc constructions in the language definition.
* Scalar, interfaces, enums, lists, directives and alias will be treated in a separate section.
* Non-inline fragments and type variables will be considered later when we introduce the concept of evaluation context.
* Input object types are banned. We have a unique type for object types for inputs as well as for outputs.

The rest of this section is influenced by {{ "cardelli02" | cite }}, {{ "sazanov09" | cite }} and {{ "pierce02" | cite}}. We will discuss similarities and differences in details later, since the abstract syntax of the language is still under revision and it could change.
