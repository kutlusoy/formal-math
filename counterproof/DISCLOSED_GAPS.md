# Gaps and softenings that the paper discloses itself

Sources: paper.pdf (Sections 1.2, 2, 3, Appendix Q) and the Lean files of `vp-vnp/`. Nothing here is hidden material; each point is stated in the paper. The assessment under each point is a reading, not a verified result.

## 1. Parts of the proof exist only in Lean

The printed text describes these steps and states that exactness is proved only in the Lean development:

- the straight-line program of part (d) and the counts of part (e) of one lemma in the contracting case (Formalization note before Section G);
- the universal tape automaton of Proposition I.1 (exactness);
- the evaluator and the cutting program `G` of Theorem J.3 (exactness and bounds);
- the constructions of Propositions E.1 and M.2, the induction of Lemma E.4, the word of Lemma F.2, the averaging of Lemma F.1, the mean `E` of Section C, the semantics of scripts inside the evaluator.

Assessment: the paper alone is not a human-checkable proof of the contracting case. Correctness rests on the Lean kernel plus on the statements being the intended ones. Appendix Q.3 lists places where a Lean statement is only argued to match the printed notion: `def_law` lists three fields of the structure in one direction; no theorem restates the value of a tree as the value of a network of Section H; `lem_circuit_phi` states what is used of `Phi`, not that it equals the printed sum over words. These are the bridges where a mismatch between paper and Lean could hide, but a mismatch there would not make the Lean main theorem false; it would make the paper's explanation of it inaccurate.

## 2. Not formalized

Remark N.6 (determinantal complexity), the flattening-rank example after Definition A.1, the remarks after Theorem D.2, the fact that `r` in the proof of Proposition A.5 is also a limit, and the factor three between two ways of counting gates.

Assessment: a Lean theorem that compiles cannot depend on an unformalized statement. None of these is on the route to `Solution.mainTheorem` and its siblings. Remark N.6 is the only one with content: it is the consequence for approximation by determinants, and it is therefore the claim of the paper that has no machine check.

## 3. Differences between paper and Lean (Appendix Q.3)

Different constants (for example `theta_n` in Lemma F.3, 14 instead of 16 in the approximate flat bound), `_printed` variants of Lemma E.3 and Propositions E.5, E.10, stronger or more general forms of many lemmas, a fixed ultrafilter (`hyperfilter`) in Section C, different readings of constructs in Section I.1, `HC_0 = 1`, rounding of quotients, and theorems that take the conclusion of Theorem J.4 as a hypothesis (`CutHyp`).

Assessment: the Lean development is the authority, the paper is a commentary. A reader who checks the paper's arithmetic checks a nearby proof, not the verified one. The text itself says Lean comments may "say a little more than the step that they name proves".

## 4. Not analysed in the paper

- Barriers: relativization, algebrization, algebraic natural proofs. The flat case uses spectral points that exist only by Zorn's lemma, so the property is not constructive. The contracting case ends in a diagonal argument.
- Step 5 of the contracting case deserves human scrutiny because it is unusual: a circuit for the permanent yields an accelerator whose named constants are advice that depends on the circuit and is longer than the running time at the scale `v`. The argument moves the names in front of the sum (`lem_postpone`), iterates to larger scales (`prop_next`), reduces to a finite field `E` of the identities in the constants, and finally applies the accelerator to a program that guesses a bit, which gives a value `V` with `V = 1 + V` in a nonzero ring (`thm_noacc`).
- Which of the two cases holds over a given field is unknown, and mutual exclusion is not shown.
- Derandomisation of identity testing (Kabanets and Impagliazzo 2004): their theorem says that a deterministic polynomial-time identity test implies NEXP not in P/poly or that the permanent has no polynomial-size arithmetic circuits. If the paper is right, the second alternative holds, so the implication is satisfied and says nothing new. The converse direction needs much stronger (nearly exponential) lower bounds than the quasi-polynomial one proved. The paper says it has not worked this out.

## 5. Fidelity of the statement was judged only by AI readers

Appendix Q.1: "No human mathematician has checked the development, the statement file or the proofs."

Assessment: `Statement.lean` is about 100 lines and imports only Mathlib. A human check should cover: the circuit model (`Computes`), `hc` via `IsCycleOn Set.univ`, `perm` via the sum of `prod X (sigma i, i)`, the real-power expression in `Beyond`, the quantifier order of `MainTheorem`, `Approximates` over `LaurentSeries`, and the class definitions. An independent reading in this folder found no deviation (see README.md and VARIANTS.md).
