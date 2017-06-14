# Well-typed fragments

Let us assume that $$\mathit{User}$$ is a subtype of $$\mathit{Person}$$.

* $$\mathit{User} = (\mathbf{name}.\mathit{String},\mathbf{lastLogin}.\mathit{Int})$$,
* $$\mathit{Person} = (\mathbf{name}.\mathit{String})$$

$$\mathit{User}, u \vdash \langle \mathit{Person} \rangle.\mathbf{name} \to \mathit{Person}, u \triangleright \mathbf{name}$$ is a sort of upcasting. Since $$u: \mathit{User}$$, we can infer $$u: \mathit{Person}$$, too.

$$\mathit{Person}, u \vdash \langle \mathit{User} \rangle.(\mathbf{name}, \mathbf{lastLogin}) $$ has two possible derivations. If $$u$$ is not $$\mathit{User}$$, then we get $$0$$. Otherwise,  $$\mathit{User}, u \triangleright (\mathbf{name}, \mathbf{lastLogin})$$. The second case is a "safe" downcasting. It is safe because at run time we know for sure that $$u$$ is $$\mathit{User}$$.

In general, fragments are applied to any schema, but well-typed fragments require that $$t \downarrow T$$. This condition is needed to guarantee that the subterm is evaluable in the new context.

For example, in the first case, $$\mathit{Person} \leq \mathbf{name}.\top$$ and $$t: \mathbf{name}.\top$$. On the contrary, $$\langle \mathit{Person} \rangle.(\mathbf{name}, \mathbf{lastLogin})$$ would not have been well-typed since $$\mathbf{lastLogin}$$ is not a field in $$\mathit{Person}$$.

As in the real GraphQL, we can also have queries like this

$$ \langle \mathit{Person} \rangle.\langle \mathit{User} \rangle.(\mathbf{name}, \mathbf{lastLogin})$$

This query is well-typed as the following derivation tree proves.

<table class="deduction-tree">
    <tr>
        <td>
          <table class="deduction-tree">
              <tr>
                  <td>
                    <table class="deduction-tree">
                        <tr>
                            <td>
                              ...
                            </td>
                            <td class="rulename" rowspan="2">
                              <div class="rulename"></div>
                            </td>
                        </tr>
                        <tr><td class="conc">
                          $$ (\mathbf{name}, \mathbf{lastLogin}): (\mathbf{name}.\top, \mathbf{lastLogin}.\top) $$
                        </td></tr>
                    </table>
                  </td>
                  <td>
                    <table class="deduction-tree">
                        <tr>
                            <td>
                              ...
                            </td>
                            <td class="rulename" rowspan="2">
                              <div class="rulename"></div>
                            </td>
                        </tr>
                        <tr><td class="conc">
                          $$ \mathit{User} \leq (\mathbf{name}.\top, \mathbf{lastLogin}.\top) $$
                        </td></tr>
                    </table>
                  </td>
                  <td class="rulename" rowspan="2">
                    <div class="rulename"></div>
                  </td>
              </tr>
              <tr><td class="conc" colspan="2">
                $$ \langle \mathit{User} \rangle.(\mathbf{name}, \mathbf{lastLogin}): \top $$
              </td></tr>
          </table>
        </td>
        <td>
          <table class="deduction-tree">
              <tr>
                  <td>
                  </td>
                  <td class="rulename" rowspan="2">
                    <div class="rulename"></div>
                  </td>
              </tr>
              <tr><td class="conc">
                $$ \mathit{Person} \leq \top $$
              </td></tr>
          </table>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc" colspan="2">
      $$ \langle \mathit{Person} \rangle.\langle \mathit{User} \rangle.(\mathbf{name}, \mathbf{lastLogin}): \top $$
    </td></tr>
</table>

Since $$\mathit{Person}$$ has a $$\mathbf{name}$$ field, we could also write,

$$ \langle \mathit{Person} \rangle.(\mathbf{name}, \langle \mathit{User} \rangle.\mathbf{lastLogin})$$

that is well-typed, too.

Let's see the case with disjoint unions. Consider these two types:

* $$\mathit{Cat} = \{ \mathbf{name}.\mathit{String}, \mathbf{meow}.\mathit{Bool}\}$$,
* $$\mathit{Dog} = \{ \mathbf{name}.\mathit{String}, \mathbf{bark}.\mathit{Bool}\}$$

On the contrary of the previous case,

$$\langle \mathit{Cat}+\mathit{Dog} \rangle. \mathbf{name}$$

is not well typed. Indeed, a term of type $$\mathit{Cat}+\mathit{Dog}$$ has form $$\mathit{inl}\, t$$ or $$\mathit{inr}\, t$$ and does not have a field $$\mathbf{name}$$. Note that we cannot have queries like this neither in the real GraphQL. With non-disjoint union it would be different, since $$\mathbf{name}$$ property is in the intersection of $$\mathit{Cat}$$ and $$\mathit{Dog}$$.

Now, in order to get a well-typed query, we need to project union terms to a simple object term.

$$\langle \mathit{Cat}+\mathit{Dog} \rangle. \langle \mathit{Cat} \rangle.  \mathbf{name}$$

The query is well typed.

<table class="deduction-tree">
    <tr>
        <td>
          <table class="deduction-tree">
              <tr>
                  <td>
                    <table class="deduction-tree">
                        <tr>
                            <td>
                              ...
                            </td>
                            <td class="rulename" rowspan="2">
                              <div class="rulename"></div>
                            </td>
                        </tr>
                        <tr><td class="conc">
                          $$ \mathbf{name} : \mathbf{name}.\top $$
                        </td></tr>
                    </table>
                  </td>
                  <td>
                    <table class="deduction-tree">
                        <tr>
                            <td>
                              ...
                            </td>
                            <td class="rulename" rowspan="2">
                              <div class="rulename"></div>
                            </td>
                        </tr>
                        <tr><td class="conc">
                          $$ \mathit{Cat} \leq \mathbf{name}.\top $$
                        </td></tr>
                    </table>
                  </td>                  
                  <td class="rulename" rowspan="2">
                    <div class="rulename"></div>
                  </td>
              </tr>
              <tr><td class="conc" colspan="2">
                $$ \langle \mathit{Cat} \rangle.\mathbf{name}: \top $$
              </td></tr>
          </table>
        </td>
        <td>
          <table class="deduction-tree">
              <tr>
                  <td>
                  </td>
                  <td class="rulename" rowspan="2">
                    <div class="rulename"></div>
                  </td>
              </tr>
              <tr><td class="conc">
                $$ \mathit{Cat} + \mathit{Dog} \leq \top $$
              </td></tr>
          </table>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc" colspan="2">
      $$ \langle \mathit{Cat} + \mathit{Dog} \rangle.\langle \mathit{Cat} \rangle.\mathbf{name}: \top $$
    </td></tr>
</table>
