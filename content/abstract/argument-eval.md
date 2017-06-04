# Argument evaluation

Arguments are restricted to be values. This is inline with GraphQL rules. However, the reason is that terms as arguments could be problematic. For example, consider a possible evaluation rule.

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
      $$ \Sigma, u \vdash m(x: t_{1}).t_{2} \to m(x: t'_{1}).t_{2} $$
    </td></tr>
</table>

The rule is applied with respect to a context $$\Sigma, u$$. But $$t_1$$ must be evaluated on the root schema. In addition, it is not clear which should be its context, probably not $$u$$. Hence, for now, we omit this case and we keep it simple.
