# Resolvers and types

As we have discussed before, the implementation of a resolver is hidden to the abstract language. Resolvers are a sort of black boxes.

As a consequence also the output of a resolver has a format meaningful for the hidden subsystem, but not necessarily for the abstract language.

For example, let us consider a simple term $$\mathbf{user}(\mathit{x}: 1).(\mathbf{name}, \mathbf{address}.\mathbf{street})$$ with type $$\mathbf{user}(\mathit{x}: \mathit{Nat}).\mathbf{name}.\mathit{String},\mathbf{address}.\mathbf{street}.\mathit{String}$$. The output of the resolver $$\rho_{\mathbf{user}}$$ is not necessarily a value of type $$\mathbf{name}.\mathit{String},\mathbf{address}.\mathbf{street}.\mathit{String}$$. On the contrary, it is an internal representation of an item that will be fed to other resolvers.

For example, we can have different internal represenations:

* $$ \mathit{name}.\mathit{"John"},\mathit{address}.\mathit{street}.\mathit{"Milky way"} $$ (e.g. MongoDB backend with nested fields).
* $$ \mathit{name}.\mathit{"John"},\mathit{addressId}.\mathit{"uid1234"} $$ (e.g. SQL backend with foreign keys).
* $$ \mathit{"uid9887"} $$.

Only the first case happens to have type $$\mathbf{name}.\mathit{String},\mathbf{address}.\mathbf{street}.\mathit{String}$$!

However, also the other cases are valid. It is responsability of the next resolvers $$\rho_{\mathbf{name}}$$ and $$\rho_{\mathbf{address}}$$ to handle the internal represenations properly. For example, $$\rho_{\mathbf{address}}$$ can use the foreign key $$\mathit{addressId}$$ to retrieve a row in a SQL table `Addresses`.
