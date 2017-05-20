# Execution

A query is executed in a context $$\Sigma, u$$, where $$\Sigma$$ is a schema $$(\Sigma_T, \Sigma_\rho)$$ and $$u$$ is a value, called parent or root.

An execution step is a relation $$\Sigma, u \vdash t \to t'$$. Sometimes, we write $$T, u \vdash t \to t'$$ when we want to highlight the type $$T$$ of the schema.

The execution semantics boils down to the following operational rules.

### Empty schema

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

<table class="deduction-tree">
    <tr>
        <td>
        $$ u \leq \Sigma_T $$
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

### Fields

**no result**

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

**application**

<table class="deduction-tree">
    <tr>
        <td>
          $$\rho_m \in \Sigma_{\rho}$$ and $$\rho_{m}(u, x:v)= v'$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash m(x: v).t \to m_{(x: v)}. v' \triangleright t $$
    </td></tr>
</table>

**argument evaluation**

<table class="deduction-tree">
    <tr>
        <td>
          $$\Sigma, u \vdash t_{1} \to t'_{1}$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ u \vdash m(x: t_{1}).t_{2} \to m(x: t'_{1}).t_{2} $$
    </td></tr>
</table>

**nesting**

<table class="deduction-tree">
    <tr>
        <td>
          $$\pi_{m}(\Sigma), 0 \vdash t \to t'$$
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

> Not considered for now

<table class="deduction-tree">
    <tr>
        <td>
          $$u \leq T$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ u \vdash \langle T \rangle.t \to  t$$
    </td></tr>
</table>

<table class="deduction-tree">
    <tr>
        <td>
          $$u \nleq T$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ u \vdash \langle T \rangle.t \to  0$$
    </td></tr>
</table>

### Context

If we apply a context to a value, we can skip the value. In other words, we ignore the result of a query and we decide to return our favorite term, stubbornly.

**skip**

<table class="deduction-tree">
    <tr>
        <td>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash v \triangleright w \to w $$
    </td></tr>
</table>

Otherwise, if the term is not a value, we evaluate the term in a new context.

**new context**

<table class="deduction-tree">
    <tr>
        <td>
          $$\Sigma, v \vdash t \to t'$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash v \triangleright t \to  t'$$
    </td></tr>
</table>

Then, we can propagate contexts down to the hierarchy formed by selection sets.

**context nesting**

<table class="deduction-tree">
    <tr>
        <td>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash (t^{i=1 \ldots n}) \to  (u \triangleright t^{i=1 \ldots n})$$
    </td></tr>
</table>

Here, $$\triangleright$$ is introduced on the right hand side of the arrow. In addition, we could apply the same rules several times, on the contrary of the application case, where another context is created. Hence, at some point of the execution, we could have terms of this form $$ v \triangleright v \triangleright \ldots \triangleright t$$. However, the only reduction we can apply is context creation and, eventually, we will apply a $$u \vdash t$$.

### Sets

**set**

<table class="deduction-tree">
    <tr>
        <td>
          $$\Sigma, u \vdash t_j \to t'_j$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash (t^{i=1 \ldots j-1}t_jt^{k=j+1 \ldots n}) \to  (t^{i=1 \ldots j-1}t'_jt^{k=j+1 \ldots n})$$
    </td></tr>
</table>
