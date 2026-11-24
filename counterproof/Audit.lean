import Solution

open Statement

-- Untested. Run from vp-vnp/ after `lake build`.

#print axioms Solution.mainTheorem
#print axioms Solution.mainTheoremApprox
#print axioms Solution.separation
#print axioms Solution.separationClosure
#print axioms Solution.permanent_over_real

-- The proved theorems have exactly the stated types, in universe 0 as well.
example : MainTheorem.{0} := Solution.mainTheorem
example : MainTheoremApprox.{0} := Solution.mainTheoremApprox
example : Separation.{0} := Solution.separation
example : SeparationClosure.{0} := Solution.separationClosure

-- The polynomials of the statement are those of the proof.
example (F : Type) [Field F] (m : ℕ) : hc F m = Nc.genHC F m := rfl

example (F : Type) [Field F] (m : ℕ) : perm F m = Nc.genPerm F m := by
  simp [perm, Nc.genPerm, Matrix.permanent]

-- Non-vacuity of the circuit model: a single variable has a circuit with one gate.
example (F : Type) [Field F] (v : Fin 2 × Fin 2) :
    Computes (MvPolynomial.X v : MvPolynomial (Fin 2 × Fin 2) F) 1 :=
  ⟨fun _ => MvPolynomial.X v, fun k hk => Or.inl ⟨v, rfl⟩, 0, by omega, rfl⟩
