# Typing

## Typing rules

**T-NULL**

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

**T-ERR**

<table class="deduction-tree">
    <tr>
        <td>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Gamma \vdash \mathbf{err}: \bot $$
    </td></tr>
</table>

**T-HOLE**

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

**T-SCA**

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

**T-VAR**

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

**T-FLD-1**

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

**T-FLD-2**

<table class="deduction-tree">
    <tr>
        <td>
          $$\Gamma \vdash v_1: T_1$$ &nbsp;&nbsp;&nbsp; $$\Gamma \vdash t_2: T_2$$
        </td>
        <td class="rulename" >
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Gamma \vdash  m_{( x: v_1 \ldots)}.t_2 : m(x: T_1 \ldots).T_2 $$
    </td></tr>
</table>

**T-CTX**

<table class="deduction-tree">
    <tr>
        <td>
        $$t \downarrow \Sigma_T$$  &nbsp;&nbsp;&nbsp; $$\Gamma \vdash t: T$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$\Gamma \vdash  \Sigma, v \triangleright t: \top$$
    </td></tr>
</table>

$$\downarrow$$ is read "matches" and it is defined in next section.

**T-PAR**

<table class="deduction-tree">
    <tr>
        <td>
        $$\Gamma \vdash t_1: T_1$$ &nbsp;&nbsp;&nbsp; $$\Gamma \vdash t_2: T_2$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$\Gamma \vdash  t_1, t_2 : T_1, T_2$$
    </td></tr>
</table>

**T-FRG-1**

<table class="deduction-tree">
    <tr>
        <td>
        $$t \downarrow T$$ &nbsp;&nbsp;&nbsp; $$\Gamma \vdash t: T'$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$\Gamma \vdash  \langle T \rangle.t: \top$$
    </td></tr>
</table>

**T-FRG-2**

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
      $$\Gamma \vdash  \mathit{inl}\,t: T+U$$
    </td></tr>
</table>

**T-FRG-3**

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
      $$\Gamma \vdash  \mathit{inr}\,t: U+T$$
    </td></tr>
</table>

## Subtyping rules

**S-RFL**

<table class="deduction-tree">
    <tr>
        <td>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ T \leq T$$
    </td></tr>
</table>

**S-TRA**

<table class="deduction-tree">
    <tr>
        <td>
          $$T \leq U$$ and $$U \leq S$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ T \leq S$$
    </td></tr>
</table>

**T-SUB**

<table class="deduction-tree">
    <tr>
        <td>
          $$\Gamma \vdash t: T$$ and $$T \leq U$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Gamma \vdash t: U$$
    </td></tr>
</table>

**S-TOP**

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

**S-BOT**

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

**S-WIDTH**

<table class="deduction-tree">
    <tr>
        <td>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ U,T \leq T$$
    </td></tr>
</table>

**S-PERM**

<table class="deduction-tree">
    <tr>
        <td>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ U,T \leq T,U$$
    </td></tr>
</table>

**S-DEPTH**

<table class="deduction-tree">
    <tr>
        <td>
         $$T \leq T'$$ and $$U \leq U'$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ T,U \leq T',U' $$
    </td></tr>
</table>

**S-FLD-1**

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

**S-FLD-2**

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
      $$ m( x: T_1 \ldots).T_2 \leq m_{( x: U_1 \ldots)}.U_2$$
    </td></tr>
</table>

**S-SUM**

We take the usual definition of subtyping for union that can be found in the literature.

<table class="deduction-tree">
    <tr>
        <td>
          $$T \leq T'$$ and $$U \leq U'$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ T+U \leq T'+U' $$
    </td></tr>
</table>

Note that $$T \nleq T+U$$ because union is disjoint!
