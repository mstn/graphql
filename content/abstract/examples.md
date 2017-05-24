# More Examples

Let us consider the following schema $$\Sigma$$:

$$
\mathbf{user}(\mathbf{id}: \mathit{Nat}).(\mathbf{name}.\mathit{String}, \mathbf{addr}.(\mathbf{street}.\mathit{String},  \mathbf{num}.\mathit{Nat}))
$$

Where resolve functions are defined as below.

* $$\rho_{\mathbf{user}}(0, \mathbf{id}:1) = (\mathbf{id}.1,\mathbf{name}.\mathit{"John"}) = \mathit{john}$$;
* $$\rho_{\mathbf{addr}}(\mathit{john}) = (\mathbf{street}.\mathit{"Milky way"}, \mathbf{num}.3) = \mathit{addr}$$
* $$\rho_{\mathbf{name}}$$, $$\rho_{\mathbf{street}}$$, $$\rho_{\mathbf{num}}$$ are projections.

We want to perform this query $$t$$:

$$
\mathbf{user}(\mathbf{id}: 1).(\mathbf{name}, \mathbf{addr}.\mathbf{street})
$$

In order to execute a query $$t$$ against a datasource with type $$T$$, we have to carry out three steps.

* Find a type $$T'$$ such that $$t: T'$$;
* Check if query and schema match, that is, $$T \leq T'$$;
* Execute $$t$$ with context $$\Sigma, 0$$.

In our example, the type of $$t$$ is $$\mathbf{user}(\mathbf{id}: \mathit{Nat}).(\mathbf{name}.\top, \mathbf{addr}.\mathbf{street}.\top)$$. The derivation tree is this one.

<table class="deduction-tree">
    <tr>
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
                $$ 1: \mathit{Nat} $$
              </td></tr>
          </table>
        </td>
        <td>
        <table class="deduction-tree">
            <tr>
                <td>
                  <table class="deduction-tree">
                      <tr>
                          <td>
                            $$[\cdot] : \top$$
                          </td>
                          <td class="rulename" rowspan="2">
                            <div class="rulename"></div>
                          </td>
                      </tr>
                      <tr><td class="conc">
                        $$ \mathbf{name}:  \mathbf{name}.\top$$
                      </td></tr>
                  </table>
                </td>
                <td>
                  <table class="deduction-tree">
                      <tr>
                          <td>
                          <table class="deduction-tree">
                              <tr>
                                  <td>
                                    $$[\cdot] : \top$$
                                  </td>
                                  <td class="rulename" rowspan="2">
                                    <div class="rulename"></div>
                                  </td>
                              </tr>
                              <tr><td class="conc">
                                $$ \mathbf{street}: \mathbf{street}.\top $$
                              </td></tr>
                          </table>
                          </td>
                          <td class="rulename" rowspan="2">
                            <div class="rulename"></div>
                          </td>
                      </tr>
                      <tr><td class="conc">
                        $$ \mathbf{addr}.\mathbf{street}:  \mathbf{addr}.\mathbf{street}.\top$$
                      </td></tr>
                  </table>
                </td>
                <td class="rulename" rowspan="2">
                  <div class="rulename"></div>
                </td>
            </tr>
            <tr><td class="conc" colspan="2">
              $$ (\mathbf{name}, \mathbf{addr}.street): (\mathbf{name}.\top, \mathbf{addr}.\mathbf{street}.\top) $$
            </td></tr>
        </table>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc" colspan="2">
      $$ \mathbf{user}(\mathbf{id}: 1).(\mathbf{name}, \mathbf{addr}.\mathbf{street}): \mathbf{user}(\mathbf{id}: \mathit{Nat}).(\mathbf{name}.\top, \mathbf{addr}.\mathbf{street}.\top) $$
    </td></tr>
</table>

Now, we can show that $$T \leq t$$ and so query $$t$$ is executable against schema $$\Sigma$$.

<table class="deduction-tree">
    <tr>
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
                $$ \mathit{Nat} \leq \mathit{Nat} $$
              </td></tr>
          </table>
        </td>
        <td>
        <table class="deduction-tree">
            <tr>
                <td>
                  <table class="deduction-tree">
                      <tr>
                          <td>
                            $$\mathit{String} \leq \top$$
                          </td>
                          <td class="rulename" rowspan="2">
                            <div class="rulename"></div>
                          </td>
                      </tr>
                      <tr><td class="conc">
                        $$ \mathbf{name}.\mathit{String} \leq \mathbf{name}.\top$$
                      </td></tr>
                  </table>
                </td>
                <td>
                  <table class="deduction-tree">
                      <tr>
                          <td>
                          <table class="deduction-tree">
                              <tr>
                                  <td>
                                    $$\mathit{String} \leq \top$$
                                  </td>
                                  <td class="rulename" rowspan="2">
                                    <div class="rulename"></div>
                                  </td>
                              </tr>
                              <tr><td class="conc">
                                $$ (\mathbf{street}.\mathit{String},  \mathbf{num}.\mathit{Nat}) \leq \mathbf{street}.\top $$
                              </td></tr>
                          </table>
                          </td>
                          <td class="rulename" rowspan="2">
                            <div class="rulename"></div>
                          </td>
                      </tr>
                      <tr><td class="conc">
                        $$ \mathbf{addr}.(\mathbf{street}.\mathit{String},  \mathbf{num}.\mathit{Nat})) \leq \mathbf{addr}.\mathbf{street}.\top$$
                      </td></tr>
                  </table>
                </td>
                <td class="rulename" rowspan="2">
                  <div class="rulename"></div>
                </td>
            </tr>
            <tr><td class="conc" colspan="2">
              $$ (\mathbf{name}.\mathit{String}, \mathbf{addr}.(\mathbf{street}.\mathit{String},  \mathbf{num}.\mathit{Nat})) \leq (\mathbf{name}.\top, \mathbf{addr}.\mathbf{street}.\top) $$
            </td></tr>
        </table>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc" colspan="2">
      $$ \mathbf{user}(\mathbf{id}: \mathit{Nat}).(\mathbf{name}.\mathit{String}, \mathbf{addr}.(\mathbf{street}.\mathit{String},  \mathbf{num}.\mathit{Nat})) \leq \mathbf{user}(\mathbf{id}: \mathit{Nat}).(\mathbf{name}.\top, \mathbf{addr}.\mathbf{street}.\top) $$
    </td></tr>
</table>

The execution of $$t$$ unfolds to a value,

$$
\mathbf{user}(\mathbf{id}: 1).(\mathbf{name}. \mathit{"John"}, \mathbf{addr}.\mathbf{street}.\mathit{"Milkyway"})
$$

The execution steps are the following.

**1. application**

<table class="deduction-tree">
    <tr>
        <td>
          $$ \rho_{\mathbf{user}}(0, \mathbf{id}:1) = \mathit{john} $$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, 0 \vdash \mathbf{user}(\mathbf{id}: 1).(\mathbf{name}, \mathbf{addr}.\mathbf{street}) \to
        \mathbf{user}(\mathbf{id}: 1). \mathit{john} \triangleright (\mathbf{name}, \mathbf{addr}.\mathbf{street}) $$
    </td></tr>
</table>

**2. nesting+new context+set+application**
<table class="deduction-tree">
    <tr>
        <td>
          <table class="deduction-tree">
              <tr>
                  <td>
                    <table class="deduction-tree">
                        <tr>
                            <td>
                              <table class="deduction-tree">
                                  <tr>
                                      <td>
                                        $$ \rho_{\mathbf{name}}(\mathit{john}) = \mathit{"John"}$$
                                      </td>
                                      <td class="rulename" rowspan="2">
                                        <div class="rulename"></div>
                                      </td>
                                  </tr>
                                  <tr><td class="conc">
                                    $$ \pi_{\mathbf{user}(\Sigma)}, \mathit{john} \vdash  \mathbf{name} \to \mathbf{name}. \mathit{"John"} \triangleright [\cdot]$$
                                  </td></tr>
                              </table>
                            </td>
                            <td class="rulename" rowspan="2">
                              <div class="rulename"></div>
                            </td>
                        </tr>
                        <tr><td class="conc">
                          $$ \pi_{\mathbf{user}(\Sigma)}, \mathit{john} \vdash  (\mathbf{name}, \mathbf{addr}.\mathbf{street}) \to (\mathbf{name}. \mathit{"John"} \triangleright [\cdot], \mathbf{addr}.\mathbf{street})$$
                        </td></tr>
                    </table>
                  </td>
                  <td class="rulename" rowspan="2">
                    <div class="rulename"></div>
                  </td>
              </tr>
              <tr><td class="conc">
                $$ \pi_{\mathbf{user}(\Sigma)}, 0 \vdash  \mathit{john} \triangleright (\mathbf{name}, \mathbf{addr}.\mathbf{street}) \to \mathit{john} \triangleright (\mathbf{name}. \mathit{"John"} \triangleright [\cdot], \mathbf{addr}.\mathbf{street})$$
              </td></tr>
          </table>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, 0 \vdash \mathbf{user}(\mathbf{id}: 1). \mathit{john} \triangleright (\mathbf{name}, \mathbf{addr}.\mathbf{street})  \to \mathbf{user}(\mathbf{id}: 1). \mathit{john} \triangleright (\mathbf{name}. \mathit{"John"} \triangleright [\cdot], \mathbf{addr}.\mathbf{street})$$
    </td></tr>
</table>

**3. nesting+new context+set+nesting+new context+hole**
<table class="deduction-tree">
    <tr>
        <td>
          <table class="deduction-tree">
              <tr>
                  <td>
                    <table class="deduction-tree">
                        <tr>
                            <td>
                              <table class="deduction-tree">
                                  <tr>
                                      <td>

                                        <table class="deduction-tree">
                                            <tr>
                                                <td>
                                                  $$ \pi_{\mathbf{name}} \pi_{\mathbf{user}(\Sigma)}, \mathit{"John"} \vdash  [\cdot] \to  \mathit{"John"}$$
                                                </td>
                                                <td class="rulename" rowspan="2">
                                                  <div class="rulename"></div>
                                                </td>
                                            </tr>
                                            <tr><td class="conc">
                                              $$ \pi_{\mathbf{name}} \pi_{\mathbf{user}(\Sigma)}, 0 \vdash  \mathit{"John"} \triangleright [\cdot] \to  \mathit{"John"}$$
                                            </td></tr>
                                        </table>
                                      </td>
                                      <td class="rulename" rowspan="2">
                                        <div class="rulename"></div>
                                      </td>
                                  </tr>
                                  <tr><td class="conc">
                                    $$ \pi_{\mathbf{user}(\Sigma)}, \mathit{john} \vdash  \mathbf{name}. \mathit{"John"} \triangleright [\cdot] \to \mathbf{name}. \mathit{"John"}$$
                                  </td></tr>
                              </table>
                            </td>
                            <td class="rulename" rowspan="2">
                              <div class="rulename"></div>
                            </td>
                        </tr>
                        <tr><td class="conc">
                          $$ \pi_{\mathbf{user}(\Sigma)}, \mathit{john} \vdash  (\mathbf{name}. \mathit{"John"} \triangleright [\cdot], \mathbf{addr}.\mathbf{street}) \to (\mathbf{name}. \mathit{"John"}, \mathbf{addr}.\mathbf{street}) $$
                        </td></tr>
                    </table>
                  </td>
                  <td class="rulename" rowspan="2">
                    <div class="rulename"></div>
                  </td>
              </tr>
              <tr><td class="conc">
                $$ \pi_{\mathbf{user}(\Sigma)}, 0 \vdash  \mathit{john} \triangleright (\mathbf{name}. \mathit{"John"} \triangleright [\cdot], \mathbf{addr}.\mathbf{street}) \to \mathit{john} \triangleright (\mathbf{name}. \mathit{"John"}, \mathbf{addr}.\mathbf{street} $$
              </td></tr>
          </table>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, 0 \vdash \mathbf{user}(\mathbf{id}: 1). \mathit{john} \triangleright (\mathbf{name}. \mathit{"John"} \triangleright [\cdot], \mathbf{addr}.\mathbf{street}) \to \mathbf{user}(\mathbf{id}: 1). \mathit{john} \triangleright (\mathbf{name}. \mathit{"John"} , \mathbf{addr}.\mathbf{street})$$
    </td></tr>
</table>

The evaluation steps for the $$\mathbf{addr}$$ subtree are analogous and left as exercise. Finally, when the part on the right of $$\triangleright$$ is a value, we apply the skip rule.
