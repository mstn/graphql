# Safety

> **WIP.** Some details need to be fixed and proofs have not been double checked. In addition, because some parts of the language could be changed, proofs can change too. Hence, I decided to publish this section "as is" without worrying about its accurateness and correctness.

Safety is a property that sounds like a Bob Marley's song. Roughly, it says that, if a term is well-typed, everything is gonna be alright. In programming languages, bad things happen if the evaluation of a term gets stuck.

In our case, we want to be sure that, if a query matches a schema, we will see a resulting value sooner or later. We need to check, not only if a query is well-typed (i.e. we can assign a type to it), but also that the schema type must be a subtype of the query type.

However, in general, safety does not mean that the execution of a query terminates without errors. In our case, the behavior of controllers is out of our control by design. Hence, something could go wrong (e.g. field missing or with wrong type in root) and later execution steps have to raise an exception.

In the rest of this section we are following {{ "pierce02" | cite }} where safety is defined as progress plus preservation. Proofs have the same reasoning structure as in {{ "pierce02" | cite }}.

### Inversion Lemmas

**Proposition.** Let $$S \leq m(x:T_1).T_2$$, then $$S$$ has one of the forms below:
1. $$S = \bot$$;
2. $$S = m(x:U_1).U_2$$ with $$T_1 \leq U_1$$ and $$U_2 \leq T_2$$;
3. $$S = S',m(x:U_1).U_2$$ with $$T_1 \leq U_1$$ and $$U_2 \leq T_2$$;
4. $$S = m(x:U_1).U_2,S'$$ with $$T_1 \leq U_1$$ and $$U_2 \leq T_2$$.

The case for $$S \leq m_{(x:T_1)}.T_2$$ is identical and left to the reader.

_Proof._

Proof by induction on subtyping derivations.

$$S \leq m(x:T_1).T_2$$ can be the conclusion of S-BOT, S-RFL, S-TRANS, S-FLD, S-WIDTH.

If S-BOT, then $$S=\bot$$ trivially.

If S-RFL, then $$S=m(x:T_1).T_2$$ and side conditions are trivially true.

If S-TRANS, then

<table class="deduction-tree">
    <tr>
        <td>
          $$S \leq U$$ &nbsp;&nbsp;&nbsp; $$U \leq m(x:T_1).T_2$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ S \leq m(x:T_1).T_2$$
    </td></tr>
</table>

By induction hypothesis, since $$U \leq m(x:T_1).T_2$$, $$U$$ has one of the forms above.

* If $$U=\bot$$, then $$S=\bot$$ trivially.
* If $$U = m(x:V_1).V_2$$ with $$T_1 \leq V_1$$ and $$V_2 \leq T_2$$, then by induction $$S$$ has one of the forms above and conclusion follows in every case.
* If $$U=U',m(x:V_1).V_2$$ with $$T_1 \leq V_1$$ and $$V_2 \leq T_2$$, then $$S \leq U',m(x:V_1).V_2$$ and by S-WIDTH $$S \leq m(x:V_1).V_2$$. By indution the conclusion follows.
* If $$U=m(x:V_1).V_2, S'$$ with $$T_1 \leq V_1$$ and $$V_2 \leq T_2$$, apply S-PERM and then same as above.

If S-FIELD, then it holds immediately.

If S-WIDTH, again trivial.

**Proposition.** Let $$S \leq T_1,T_2$$, then $$S$$ has one of the forms below:
1. $$S = \bot$$;
2. $$S = U_1,U_2$$ with $$U_1 \leq T_1$$ and $$U_2 \leq T_2$$;
3. $$S = U_2,U_1$$ with $$U_1 \leq T_1$$ and $$U_2 \leq T_2$$.

_Proof._

Proof by induction on subtyping derivations.

$$S \leq T_1,T_2$$ can be the conclusion of S-BOT, S-RFL, S-TRANS, S-PERM, S-DEPTH, S-WIDTH.

S-BOT, S-RFL, S-PERM, S-DEPTH are trivial.

If S-WIDTH, then $$S=S',T_1,T_2$$. Side conditions are true $$S',T_1 \leq T_1$$ (S-WIDTH) and $$T_2 \leq T_2$$ (S-RFL).

If S-TRANS,

<table class="deduction-tree">
    <tr>
        <td>
          $$S \leq U$$ &nbsp;&nbsp;&nbsp; $$U \leq T_1, T_2$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ S \leq T_1,T_2$$
    </td></tr>
</table>

Then, by induction, $$U$$ is (1), (2) or (3). The first case is trivial. For the other two, we apply the inductive hypothesis and the conclusion follows immediately.

### Progress

**Proposition.** Let $$\Sigma=(S,\rho)$$ and $$u$$ be a schema and a root value, respectively. For every term $$t$$, if $$t \downarrow S$$ and $$t: T$$, then $$t=v$$ for some value $$v$$ or there exists $$t'$$ such that $$\Sigma, u \vdash t \to t'$$.

_Proof._

Proof by induction on typing derivations.

T-NULL, T-ERR, T-SCALARs, $$t$$ is already a value and we have done.

If T-HOLE, then, if $$u: S$$, apply E-HOLE, otherwise E-HOLE-ERROR.

If T-FLD-1, then

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

Since $$S \leq m(x: T_1 \ldots).T_2$$, by the inversion lemma, we have

* $$S=\bot$$, then apply E-NULL.
* $$T_1 \leq U_1$$ and $$U_2 \leq T_2$$ and $$S=m(x:U_1).U_2$$ or $$S=S',m(x:U_1).U_2$$ or $$S=m(x:U_1).U_2, S'$$. Thus there exists $$\rho_m: U \times U_1 \to U'$$, calculate $$\rho_m(u, v_1)$$ and depending on the result perform one evaluation step amongst E-APP-ERR, E-NO-RES or E-APP.

If T-FLD-2, then ...

If T-CTX and $$t = \Sigma', v \triangleright t_1$$, then we have two subcases. If $$t_1$$ is a value, apply E-SKIP. Otherwise, apply E-CTX:

<table class="deduction-tree">
    <tr>
        <td>
          $$\Sigma', v \vdash t_1 \to t_1'$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename"></div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \Sigma, u \vdash \Sigma', v \triangleright t_1 \to  \Sigma', v \triangleright t_1'$$
    </td></tr>
</table>

Indeed, since $$t$$ is well-typed, $$t_1:T'$$ and $$t_1 \downarrow S'$$. Hence, by induction, $$\Sigma', v \vdash t_1 \to t_1'$$.

If T-FRAG, trivial, one of the fragment evaluation rules can be applied.

If T-PAR, then

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

If $$t$$ is a value, we have done. Otherwise, at least one between $$t_1$$ and $$t_2$$ is not a value. Without loss of generality, assume that $$t_1$$ is not a value.

By inversion lemma:

* if $$S= \bot$$, apply E-NULL;
* if $$S = U_1,U_2$$ with $$U_1 \leq T_1$$ and $$U_2 \leq T_2$$, because $$U_1,U_2 \leq U_1$$ (S-WIDTH) and $$U_1 \leq T_1$$ (hyothesis), then $$U_1,U_2 \leq T_1$$ (S-TRANS) and we can apply $$E-PAR-1$$.
* if $$S = U_2,U_1$$ with $$U_1 \leq T_1$$ and $$U_2 \leq T_2$$, apply S-PERM and then as before.

If T-SUB, then the conclusion follows by the induction hypothesis.

### Preservation

In general, evaluation rules preserves types (modulo subtyping), but not matchability. From an extensional point of view, a type represents a set of values. Thus we expect that the set of possible values will shrink at every evaluation step. Indeed, as the following proposition claims, types do not increase.

**Proposition.** Given a schema $$\Sigma=(S,\rho)$$ and $$u$$ a value, if $$t: T$$ and $$\Sigma, u \vdash t \to t'$$, then $$t': T$$.

_Proof._


Proof by induction on typing relation.

If T-NULL, T-ERR or T-SCALAR, the only applicable rule is E-NULL. Conclusion follows trivially.

If T-HOLE, we can apply E-NULL, E-HOLE and E-HOLE-ERR. Type is preserved by application. Note that $$t' \downarrow S$$ fails for E-HOLE-ERR.

If T-FLD-1, we can apply E-APP-ERR, E-NO-RES, E-APP. In the first two cases $$t': m(x:T_1).\bot \leq m(x:T_1).T_2$$ (as in T-HOLE matching is not preserved). For E-APP, since $$ \Sigma',v' \triangleright t_2: T_2 $$, $$t': m(x:T_1).T_2$$.

If T-FLD-2, we can apply E-NEST. It follows from induction hypothesis.

If T-FRAG, $$T = \top$$ and it is trivially true.

If T-CTX, we can apply E-SKIP or E-CTX. For E-SKIP it is immediate. For E-CTX follows from induction hypothesis.

If T-PAR, it follows from induction hypothesis.
