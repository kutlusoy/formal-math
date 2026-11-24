# Variants that could revise the VP != VNP development

Status legend: `read ok` (read, no flaw found), `not run` (needs the Lean build), `not read` (not examined in depth), `open` (no way to settle without more work or outside input).

## A. The statement says something different from what is claimed

| # | Variant | How a flaw would show | Status |
|---|---|---|---|
| A1 | Circuit model too weak or too strong (free constants, gate counting, sharing of gates) | `Statement.Computes` differs from the standard model | read ok, standard model, variables and constants count as gates |
| A2 | `hc` or `perm` is not the intended polynomial | different support, e.g. not exactly the (m-1)! single-cycle permutations | read ok, `IsCycleOn Set.univ`; `perm` is Mathlib `Matrix.permanent` of the generic matrix |
| A3 | `Beyond` is trivially true or the constant is vacuous | `c <= 0`, wrong parenthesisation, `m^(...)` below polynomial | read ok, `c = 1/1600^2 > 0`, exponent `c * (logb 2 m)^(1/3)` |
| A4 | Quantifier order | `m0` allowed to depend on the field, or `c` on `p` | read ok, `c` absolute, `m0` depends on `p` only, non-prime `p` handled by emptiness of `CharP` |
| A5 | `VP`, `VNP`, `VPBar` differ from Valiant's classes | degree or variable bound missing, summation range wrong | read ok, matches the textbook definitions |
| A6 | `Approximates` too weak | coefficients of `eps^i`, `i <= 0` not tied to `f` | read ok, equals `f + eps*g`, `g` over power series |
| A7 | Universe levels | theorem only for fields in `Type`, statement says `Type u` | read ok, `Solution` holds for every `u`; the transfer lemma moves any `F : Type u` to `KK : Type` |
| A8 | Strictness `VP < VNP` needs `HC` in `VNP` | `HC` not shown to be in `VNP` | not read in detail, `Paper.cor_allclasses` |

## B. The build does not behave as claimed

| # | Variant | How a flaw would show | Status |
|---|---|---|---|
| B1 | Extra axioms, `sorry`, `native_decide`, custom elaborators | `#print axioms` lists more than `propext`, `Classical.choice`, `Quot.sound` | source search clean, build not run |
| B2 | Comparator or nanoda check not reproducible | CI script fails | not run |
| B3 | The pinned Mathlib commit contains a wrong lemma | a used lemma has a false statement that the kernel accepted | open, very unlikely |
| B4 | Kernel bug | independent kernel (nanoda) rejects | not run |

## C. The mathematics of the core

| # | Variant | How a flaw would show | Status |
|---|---|---|---|
| C1 | Case split: flat or contracting over every field (`thm_alt`) | the proof of `thm_alt_euclidean` has a gap, or `Contracting` is stated so that its negation is too strong | structure read ok (`by_cases` plus `thm_alt_euclidean`), the 900 lines of `thm_alt_euclidean` not read |
| C2 | Spectral points are vacuous or do not exist | `def_spectral` unsatisfiable | read ok, ordinary Strassen-type definition; non-vacuity needs prop_gauge (Zorn) |
| C3 | Flat case: balanced decomposition, few-terms lemma, cube estimate, numerical constants | an inequality chain (E.2) fails for admissible parameters | paper arithmetic of E.11 reproduced, Lean lemmas not read |
| C4 | Contracting case: Poincare inequality, trees, cuts, accelerators, diagonal argument | a hidden dependence of constants on `p` or `m` that breaks the comparison with the flat bound | comparison `thm_allfields_exceeds` read ok, the rest not read |
| C5 | Reduction of clause sums to `perm` or `hc` | wrong gadget, wrong blow-up | structure read; Proposition M.2 gadget could be brute-forced on tiny instances |
| C6 | Low-degree reduction (`lem_lowdeg`) over small fields | interpolation needs a large field | read ok in paper, handled by passing to `KK` algebraically closed |
| C7 | Transfer to the algebraic closure of the prime field | specialisation does not preserve the output | read ok (Lean and paper) |
| C8 | Approximate case (Proposition N.4) | truncation of Laurent series changes the output | truncation step read ok, Proposition N.4 not read |

## D. Plausibility checks (a correct proof must pass)

| # | Test | Outcome |
|---|---|---|
| D1 | Determinant must escape | paper locates the failure in the reduction to the permanent (arrows P) |
| D2 | Permanent in characteristic 2 equals the determinant | excluded by the guard `p != 2` for `perm`; only `hc` claimed there |
| D3 | Boolean circuits must escape | counterexample `(x^2 - x)*x2*...*xk` in the paper, steps C fail |
| D4 | Low treewidth networks (path) have small circuits | Figure 3 of the paper, dense complete network used |
| D5 | Lower bound must stay below known upper bound `2^O(m)` | `2^((log m)^(4/3)/1600^2)` is far below |
| D6 | Bound for `f_{k,ell}` must stay below the contraction upper bound | `ell*k^(3/2)/16 <= ell*k(k-1)/2` |
| D7 | Barriers: relativization, algebrization, natural proofs | open, the paper says not analysed; contracting case ends in a diagonal argument |
| D8 | Size of the jump | no earlier general lower bound beyond `n log d` is known; a jump to quasi-polynomial is extraordinary and needs human review |

## Where a revision is most likely

1. B1, B2, B4: run `lake build` and the axiom check locally. This is the only decisive test.
2. A-block: a human reading of `Statement.lean`.
3. C1, C3, C4, C8: the large unread Lean parts. A flaw there would have to survive the kernel, so it would have to be a definition that means something else than the paper says.
4. D7: a barrier analysis. This could produce a conceptual objection even if the Lean proof is sound.
