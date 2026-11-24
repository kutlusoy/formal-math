# Gegenbeweis: counterproof attempt for "VP != VNP over every field"

Target: `vp-vnp/` (paper.pdf and its Lean 4 development).

Author: Claude (Anthropic). Written on request of the repository owner, 2026-11-24.

## Result

No counterproof was found. No flaw in `Statement.lean`, in the bridge to the proof, or in the printed parameter arithmetic was detected by reading. Nothing here was compiled: the Lean toolchain and the Mathlib cache were not reachable from the sandbox, so `Audit.lean` is untested. The full build (`lake build`) and the axiom check have not been run by the author of this note.

A Lean-checked proof with only `propext`, `Classical.choice`, `Quot.sound` can only be wrong through (a) a statement that does not mean what is claimed, (b) a build that does not behave as claimed, or (c) a bug in Lean, Mathlib or the checkers. This folder tests (a) and (b) and records what was read.

## What was checked by reading

1. **Statement.lean** against the standard definitions: circuit model (constants and variables count as gates, any constant of the ring is free), `hc` as the sum over single-cycle permutations (`IsCycleOn Set.univ`), `perm` as the sum of `prod X (sigma i, i)`, `Beyond`, quantifier order (`c` absolute, `m0` depends on `p`), `Approximates` as `f + eps*g` with `g` a power series, `VP`, `VNP`, `VPBar`. No deviation found.
2. **Bridge.** `Nc.Computes`, `Nc.Family`, `Nc.VP`, `Nc.VNP` are textually the same as the `Statement` versions; `Nc.genHC` and `Nc.genPerm` (Mathlib `Matrix.permanent`) equal `hc` and `perm`. `Solution.lean` transports by definitional equality only.
3. **Cheating constructs.** All 324 Lean files searched for `sorry`, `axiom`, `native_decide`, `unsafe`, `implemented_by`, `extern`, `opaque`, `elab`, `macro`, `syntax`, `run_cmd`, `initialize`: none outside `Challenge.lean`. `set_option` is limited to linters, heartbeats and instance size.
4. **Parameter arithmetic of Theorem E.11** reproduced: with `k = r^2`, `ell = 100 r` the blow-up gives `log m <= 1600 r^3`, and `log L >= ell k^(3/2)/16 = 25 r^4 / 4`, hence `log L > (log m)^(4/3) / 1600^2`. Consistent.
5. **Consistency with upper bounds.** The flat-case bound `ell k^(3/2)/16` is below the trivial upper bound `ell k(k-1)/2` for `f_{k,ell}` (contraction over all edge strings). No contradiction.
6. **Low treewidth.** A path network has a balanced cut crossed by one wire and has small circuits; the paper handles this explicitly (Figure 3, complete network vs path). So the "dense graph" requirement is used.
7. **Determinant and characteristic 2.** The proof must fail for the determinant; the paper locates the failure in the reduction of clause sums to the permanent (arrows P). In characteristic 2 only `hc` is claimed (`p != 2 ->` guard in the statement). Consistent.

## What was not checked

- The 73,000 lines of proof themselves, beyond the searches above.
- `lem_transfer` and `lem_transfer_approx` (passing from an arbitrary field `F : Type u` to an algebraically closed field of the same characteristic in universe 0). Mathematically this is a specialization of the finitely many circuit constants; this is the most delicate bridge and the first thing to read.
- Remark N.6 (determinantal complexity) is not formalized upstream.
- Barriers (relativization, algebrization, natural proofs): the paper itself says they were not analysed. The contracting case ends in a diagonal argument.
- Practical content: the constant is `c = 1/1600^2` and `m0` is not effective, so the bound is asymptotic only.

## How to run the audit

From `vp-vnp/` in a checkout with elan installed:

    lake exe cache get
    lake build
    cp ../counterproof/Audit.lean scripts/Audit.lean
    lake env lean scripts/Audit.lean

Any error or any axiom other than `propext`, `Classical.choice`, `Quot.sound` is a lead for a real counterproof.
