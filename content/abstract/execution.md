# Execution

A query is executed in a context $$\Sigma, u$$, where $$\Sigma$$ is a schema $$(\Sigma_T, \Sigma_\rho)$$ and $$u$$ is a value, called parent or root.

An execution step is a relation $$\Sigma, u \vdash t \to t'$$. Sometimes, we write $$T, u \vdash t \to t'$$ when we want to highlight the type $$T$$ of the schema.

The execution semantics boils down to the following operational rules.

### Empty schema

**E-NULL**

<table class="deduction-tree">
    <tr>
        <td>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \bot , u \vdash t \to 0 $$
    </td></tr>
</table>

The intuition behind this rule is that every query on an empty schema yields an empty value. This rule is required in order to guarantee safety. Since $$ \bot \leq t$$ for every term $$t$$, as we have already seen, queries can be executed against an empty schema.

$$ \bot, u \vdash v$$ yields $$0$$. I do not like this rule because values are not in normal form (i.e. an evaluation step can be applied to values). However, for the moment, I will keep it as it is.

Actually, GraphQL does not allow to create empty schemas.

### Hole

**E-HOLE**

<table class="deduction-tree">
    <tr>
        <td>
        $$ u: \Sigma_T $$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash [\cdot] \to u $$
    </td></tr>
</table>

GraphQL behavior, however, requires $$u$$ to be a scalar value. In the next section we will consider an extension of the hole rule where we specify the type that the parent must have in order to apply the rule, i.e. $$[T]$$.

Note that for $$ \bot, 0 \vdash [\cdot] $$ we can apply the hole rule or the null rule. However, the result is always the same.

Finally, since $$v \leq \top$$ for every value $$v$$, we have $$ \top, v \vdash [\cdot] \to v $$.

**E-HOLE-ERR**

<table class="deduction-tree">
    <tr>
        <td>
        not $$ u: \Sigma_T $$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash [\cdot] \to \mathbf{err} $$
    </td></tr>
</table>

The root value $$u$$ is usually the output of a resolver. Since resolver implementation is an internal detail, we do not know what $$u$$ looks like until we use it. In practice, this means that the run time type of $$u$$ could not be what we expected and, if it does not match the schema, we raise an error.

### Fields

**E-NO-RES**

<table class="deduction-tree">
    <tr>
        <td>
          $$\rho_m \in \Sigma_{\rho}$$ and $$\rho_{m}(u, x:v)= 0$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash m(x: v).t \to m_{(x: v)}. 0 $$
    </td></tr>
</table>

**E-APP-ERR**

<table class="deduction-tree">
    <tr>
        <td>
          $$\rho_m \in \Sigma_{\rho}$$ and $$\rho_{m}(u, x:v) = \bot$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash m(x: v).t \to m_{(x: v)}. \mathbf{err} $$
    </td></tr>
</table>

An error is raised if the resolver fails to compute. E.g. provided arguments are not what it expects or internal errors.

**E-APP**

<table class="deduction-tree">
    <tr>
        <td>
          $$\Sigma' = \pi_m \Sigma$$ and $$\rho_m \in \Sigma_{\rho}$$ and $$\rho_{m}(u, x:v)= v'$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash m(x: v).t \to m_{(x: v)}. \Sigma', v' \triangleright t $$
    </td></tr>
</table>

**E-NEST**

<table class="deduction-tree">
    <tr>
        <td>
          $$\pi_m \Sigma, 0 \vdash t \to t'$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash m_{(x: v)}.t \to m_{(x: v)}.t' $$
    </td></tr>
</table>

### Fragments

Fragments yield new evaluation contexts. Basically, they behave as ascriptions (i.e. upcasting and "safe" downcasting).

**E-FRAG-1**

<table class="deduction-tree">
    <tr>
        <td>
          $$u: T$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash \langle T \rangle.t \to  T, u \triangleright t$$
    </td></tr>
</table>

For (disjoint) unions, we distinguish several cases: if the root has type union, then the new context will be a "projection" of the union value to one of its constituents. Otherwise, if the type condition is a union, the root value is "injected" into a union value.

**E-FRAG-2**

<table class="deduction-tree">
    <tr>
        <td>
          $$u = \mathit{inl} \, v: T+U$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash \langle T \rangle.t \to  T, v \triangleright t$$
    </td></tr>
</table>

**E-FRAG-2**

<table class="deduction-tree">
    <tr>
        <td>
          $$u = \mathit{inr} \, v: U+T$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash \langle T \rangle.t \to  T, v \triangleright t$$
    </td></tr>
</table>

**E-FRAG-3**

<table class="deduction-tree">
    <tr>
        <td>
          $$u: T$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash \langle T+U \rangle.t \to  T+U,  \mathit{inl} \, u \triangleright t$$
    </td></tr>
</table>

**E-FRAG-4**

<table class="deduction-tree">
    <tr>
        <td>
          $$u: T$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash \langle U+T \rangle.t \to  U+T,  \mathit{inr} \, u \triangleright t$$
    </td></tr>
</table>

The following is a catch-all rule whose premise is the negation of the union of the previous conditions.

**E-FRAG-ALL**

<table class="deduction-tree">
    <tr>
        <td>
          otherwise
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash \langle T \rangle.t \to  0$$
    </td></tr>
</table>

### Context

If we apply a context to a value, we can skip the value. In other words, we ignore the result of a query and we decide to return our favorite term, stubbornly.

**E-SKIP**

<table class="deduction-tree">
    <tr>
        <td>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash \Sigma', v \triangleright w \to w $$
    </td></tr>
</table>

Otherwise, if the term is not a value, we evaluate the term in a new context.

**E-CTX**

<table class="deduction-tree">
    <tr>
        <td>
          $$\Sigma', v \vdash t \to t'$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash \Sigma', v \triangleright t \to  \Sigma', v \triangleright t'$$
    </td></tr>
</table>

Do we really need context? We could rub it out. For example, we could add the evaluation step in a new context as premise of the app rule. The reason why I prefer to have two distinct rules is that, in this way, each evaluation step calls at most one resolver. In general, application could be expensive and one may want to return partial results to the client as soon as they are ready.

### Sets

**E-PAR-1**

<table class="deduction-tree">
    <tr>
        <td>
          $$\Sigma, u \vdash t_1 \to t_{1}'$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash t_1,t_2 \to  t_{1}',t_2$$
    </td></tr>
</table>

**E-PAR-2**

<table class="deduction-tree">
    <tr>
        <td>
          $$\Sigma, u \vdash t_2 \to t_{2}'$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash t_1,t_2 \to  t_{1},t_{2}'$$
    </td></tr>
</table>

### Union

The usual suspects.

**E-SUM-1**

<table class="deduction-tree">
    <tr>
        <td>
          $$T, v \vdash t \to t'$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ T+U, \mathit{inl}\,v \vdash \mathit{inl}\,t \to  \mathit{inl}\,t'$$
    </td></tr>
</table>

**E-PAR-2**

<table class="deduction-tree">
    <tr>
        <td>
          $$U, v \vdash t \to t'$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ T+U, \mathit{inr}\,v \vdash \mathit{inr}\,t \to  \mathit{inr}\,t'$$
    </td></tr>
</table>
