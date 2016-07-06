# Execution semantics

The execution semantics of our simplified GraphQL boils down to the following operational rules. We denote scalar types as $$s$$ while $$\tau$$ can denote scalar as well as more complex types. For readability, we omit the subscript $$i=1 \ldots n$$.

<table class="deduction-tree">
    <tr>
        <td>
          $$(s) v = v'$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename">$$s$$-red</div>
        </td>
    </tr>
    <tr><td class="conc">$$ s \vdash (0,v) \to v' $$</td></tr>
</table>

<table class="deduction-tree">
    <tr>
        <td>
          $$\forall i \; \pi_{m_i}(\tau) \vdash (Q_i, \rho_{m_i}(G,\overline{x}:\overline{d})) \to G_i$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename">$$\tau$$-red</div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \tau \vdash ( \{ m_i(\overline{x}:\overline{d}):Q_i \}, G ) \to \{ m_i:G_i\} $$
    </td></tr>
</table>

<table class="deduction-tree">
    <tr>
        <td>
          $$\forall i \; \tau \vdash (Q, G_i) \to G'_i$$
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename">$$[\tau]$$-red</div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ [\tau] \vdash ( Q, \{m_i:G_i\} ) \to \{m_i:G'_i\} $$
    </td></tr>
</table>

A query $$Q$$ is executed against a schema type $$\mathit{Root}$$. The execution of a query gets stuck if a derivation tree cannot be built.

**Proposition.** $$Q$$ matches type $$\tau$$ iff the execution $$\tau \vdash (Q,0) $$ is not stuck.


#### Example cont'd

In what follows, $$\mathit{hero}$$ is a shorthand for $$\rho_{\mathbf{hero}}(\emptyset, \{ \mathit{episode}:5 \})$$, which value is:

$$\begin{array}{l}
\{ \\
  \quad \mathbf{id}:1000, \\
  \quad \mathbf{name}:\mathit{"Luke \; Skywalker"}, \\
  \quad \mathbf{friends}:[1002, 1003, 2000, 2001] \\
  \quad \mathbf{appearsIn}:[4, 5, 6] \\
  \quad \mathbf{homePlanet}:\mathit{"Tatooine"} \\
\}
\end{array}$$

Applying the reduction rules above, we show some example of query executions.

First query is $$\{ \mathbf{hero}(\mathit{episode}:5): \{ \mathbf{name} \} \}$$.

<table class="deduction-tree">
    <tr>
        <td>
          <table class="deduction-tree">
            <tr>
                <td>
                  <table class="deduction-tree">
                    <tr>
                      <td>
                      $$
                        (\mathit{String}) \rho_{\mathbf{name}} \mathit{hero} = \mathit{"Luke \; Skywalker"}
                      $$
                      </td>
                      <td class="rulename" rowspan="2">
                        <div class="rulename">$$s$$-red</div>
                      </td>
                    </tr>
                    <tr><td class="conc">
                      $$\pi_{\mathbf{name}} \pi_{\mathbf{hero}}(\mathit{Root}) \vdash (0,  \rho_{\mathbf{name}} \mathit{hero} ) \to \mathit{"Luke \; Skywalker"}$$
                    </td></tr>
                  </table>
                </td>
                <td class="rulename" rowspan="2">
                  <div class="rulename">$$\tau$$-red</div>
                </td>
            </tr>
            <tr><td class="conc">
              $$ \pi_{\mathbf{hero}}(\mathit{Root}) \vdash  ( \{ \mathbf{name}, \mathbf{friends}:\{\mathbf{name}\} \}, \mathit{hero} ) \to \{ \mathbf{name}:\mathit{"Luke \; Skywalker"} \}$$
            </td></tr>
          </table>
        </td>
        <td class="rulename" rowspan="2">
          <div class="rulename">$$\tau$$-red</div>
        </td>
    </tr>
    <tr><td class="conc">
      $$ \mathit{Root} \vdash ( \{ \mathbf{hero}(\mathit{episode}:5): \{ \mathbf{name} \} \}, 0 ) \to  \{ \mathbf{hero}: \{ \mathbf{name}:\mathit{"Luke \; Skywalker"} \} \} $$
    </td></tr>
</table>

Now consider a bit more complex query $$\{ \mathbf{hero}(\mathit{episode}:5): \{ \mathbf{friends}: \{ \mathbf{name} \} \} \}$$ where $$\pi_{\mathbf{friends}} \pi_{\mathbf{hero}}(\mathit{Root})$$ is $$[Character]$$. For simplicity we show the derivation tree only for one friend of Luke, that is, Han Solo.

$$\begin{array}{l}
\{ \\
  \quad \mathbf{id}:1002, \\
  \quad \mathbf{name}:\mathit{"Han \; Solo"}, \\
  \quad \mathbf{friends}:[1000, 1003, 2001] \\
  \quad \mathbf{appearsIn}:[4, 5, 6] \\
\}
\end{array}$$

The reader can figure out how to build the tree for the other friends.

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
                      <tr><td>
                        $$ (\mathit{String}) \rho_{\mathbf{name}} \mathit{han} =  \mathit{"Han \; Solo"}$$
                      </td><td>
                          <div class="rulename">$$s$$-red</div>
                      </td></tr>
                      <tr><td class="conc">
                        $$ \pi_{\mathbf{name}} \mathit{Character} \vdash (0, \rho_{\mathbf{name}} \mathit{han}) \to \mathit{"Han \; Solo"}$$
                      </td></tr>
                    </table>
                  </td>
                  <td class="rulename" rowspan="2">
                    <div class="rulename">$$\tau$$-red</div>
                  </td>
                </tr>
                <tr><td class="conc">
                  $$ \mathit{Character} \vdash (\{ \mathbf{name} \}, \mathit{han}) \to \{ \mathbf{name}: \mathit{"Han \; Solo"} \} $$
                </td></tr>
              </table>
            </td>
            <td>
              $$ \ldots $$
            </td>
            <td class="rulename" rowspan="2">
              <div class="rulename">$$[\tau]$$-red</div>
            </td>
        </tr>
        <tr><td class="conc">
          $$[\mathit{Character}] \vdash (\{ \mathbf{name} \},  \rho_{\mathbf{friends}} \mathit{hero} ) \to
          [ \{ \mathbf{name}: \mathit{"Han \; Solo"} \}, \ldots ]$$
        </td></tr>
      </table>
    </td>
    <td class="rulename" rowspan="2">
      <div class="rulename">$$\tau$$-red</div>
    </td>
  </tr>
  <tr><td class="conc">
    $$ \mathit{Root} \vdash ( \{ \mathbf{hero}(\mathit{episode}:5): \{ \mathbf{friends}:\{ \mathbf{name} \} \} \}, 0 ) \to  \{ \mathbf{hero}: \{  \mathbf{friends}:[ \{ \mathbf{name}: \mathit{"Han \; Solo"} \}, \ldots ] \} \} $$
  </td></tr>
</table>

We can also combine queries such as $$\{ \mathbf{hero}(\mathit{episode}:5): \{ \mathbf{name}, \mathbf{friends}:\{ \mathbf{name} \} \} \}$$, but we do not show here the derivation tree for rendering issues.
