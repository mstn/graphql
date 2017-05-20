# Typing

## Typing rules

<table class="deduction-tree">
    <tr>
        <td>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Gamma \vdash 0: \bot $$
    </td></tr>
</table>

<table class="deduction-tree">
    <tr>
        <td>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Gamma \vdash [\cdot]: \top $$
    </td></tr>
</table>

<table class="deduction-tree">
    <tr>
        <td>
        for all $$n \in \mathbb{N}$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Gamma \vdash  n: \mathit{Nat} $$
    </td></tr>
</table>

Similar for strings, booleans and other scalars.

<table class="deduction-tree">
    <tr>
        <td>
          $$\Gamma(x) = T$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Gamma \vdash  x : T $$
    </td></tr>
</table>

<table class="deduction-tree">
    <tr>
        <td>
          $$\Gamma \vdash t_1: T_1$$ &nbsp;&nbsp;&nbsp; $$\Gamma \vdash t_2: T_2$$
        </td>
        <td class="rulename" >
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Gamma \vdash  m( x: t_1 \ldots).t_2 : m(x: T_1 \ldots).T_2 $$
    </td></tr>
</table>

<table class="deduction-tree">
    <tr>
        <td>
        $$\Gamma \vdash t: T$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$\Gamma \vdash  v \triangleright t: T$$
    </td></tr>
</table>

<table class="deduction-tree">
    <tr>
        <td>
        $$\Gamma \vdash t_i: T_i$$ for $$i=1 \ldots n$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$\Gamma \vdash  (t^{i=1 \ldots n}): (T^{i=1 \ldots n})$$
    </td></tr>
</table>

> Missing rule for fragments $$\langle T \rangle.t$$.

## Subtyping rules

<table class="deduction-tree">
    <tr>
        <td>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \bot \leq T$$
    </td></tr>
</table>

<table class="deduction-tree">
    <tr>
        <td>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ T \leq \top$$
    </td></tr>
</table>

<table class="deduction-tree">
    <tr>
        <td>
          $$U_1 \leq T_1$$ &nbsp;&nbsp;&nbsp; $$T_2 \leq U_2$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ m( x: T_1 \ldots).T_2 \leq m( x: U_1 \ldots).U_2$$
    </td></tr>
</table>

<table class="deduction-tree">
    <tr>
        <td>
         $$\forall i=1 \ldots m \exists ! j \in 1 \ldots n$$ such that $$T_{j} \leq U_i$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ (T^{i=1 \ldots n}) \leq (U^{i=1 \ldots m}) $$
    </td></tr>
</table>

> Note: at the moment we are not considering union.

#### Shortcut notation

We write $$T \leq t$$ for $$T \leq T' \wedge t:T'$$.

## Queries and schemas

The execution of a query $$q$$ against a datasource makes sense if it matches the schema type $$T$$ of the datasource. Formally, this means that $$T \leq q$$.

The result of the execution of a query against a matching schema is a value (see next section). The type of the result is a subtype of the query as well as the schema.
