# Unions as inputs

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
