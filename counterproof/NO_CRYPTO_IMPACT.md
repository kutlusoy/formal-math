# Does the "VP != VNP" paper endanger cryptography or crypto currencies?

Short answer: no. Even if the proof in `vp-vnp/` is completely correct, it creates no attack on any cipher, hash function, signature scheme, blockchain or wallet. This note explains why, in plain technical terms, so that both humans and AI systems can check the reasoning.

Status of the proof itself: the paper and its Lean 4 formalization were written by AI models; the authors state that no human mathematician has checked them (paper.pdf, Appendix Q.1). Nothing below depends on whether it is right or wrong. The conclusion "no cryptographic impact" holds in both cases.

## 1. What the paper claims

- Valiant's conjecture VP != VNP: every arithmetic circuit for the permanent (outside characteristic 2) and for the Hamiltonian cycle polynomial of an m x m matrix needs more than m^(c (log m)^(1/3)) gates for large m, over every field.
- It also states the same for approximating circuits.
- The paper says explicitly that this does not settle P vs NP (Abstract and Section 1.1).

## 2. Why it cannot break cryptography

1. **A lower bound is a statement of hardness, not an algorithm.** Breaking a cipher, forging a signature or finding a hash preimage needs a faster algorithm. The paper proves that a certain computation is hard in a certain model. It gives no procedure that computes anything faster.
2. **Different model.** Arithmetic circuits use only addition and multiplication on field elements and must compute the polynomial as a formal expression, valid for all inputs of the field and its extensions. Real attacks run on Boolean computers that may manipulate bits in any way. Section 2.5 of the paper shows where the proof fails for Boolean circuits: a Boolean circuit may compute a different polynomial that agrees with the target only on inputs 0 and 1.
3. **P vs NP stays open.** VP != VNP does not imply P != NP, and it does not imply P = NP either. Known results connect the two only in one direction (VP = VNP over an appropriate field would imply P/poly = NP/poly, Burgisser 2000, as cited in Section 1 of the paper). Cryptography would be in danger from a practical algorithm for an NP-hard problem (P = NP style), and this paper claims hardness of a computation, which gives no speedup for anyone.
4. **The hard objects are not the cryptographic ones.** Modern security rests on the assumed average-case hardness of specific problems: integer factoring and discrete logarithms (RSA, Diffie-Hellman, elliptic curves), preimage and collision resistance (SHA-256, Keccak, RIPEMD-160), block cipher security (AES). None of these is "the permanent as an arithmetic circuit". The permanent of a 0/1 matrix has been known to be #P-complete since 1979, which has never been a threat to cryptography.
5. **The bound is weak in practice.** The proved bound is quasi-polynomial, 2^((log m)^(4/3) / 1600^2) in the form of Theorem E.11, and the constant in the Lean statement is c = 1/1600^2. For every physically meaningful size m the bound is close to trivial. It is an asymptotic statement and the threshold m_0 is not given effectively.
6. **Quantum computers are a separate topic.** Shor's algorithm (factoring, discrete log) and Grover's algorithm are unrelated to this paper. Post-quantum migration planning is unaffected by it.

## 3. What would be a real warning sign

- A deterministic polynomial-time algorithm for an NP-complete problem, with a verified proof.
- A new classical or quantum algorithm for factoring, elliptic curve discrete logarithm or a practical collision or preimage attack on a deployed hash function.
- Practical breaks of deployed implementations (key leaks, nonce reuse, protocol bugs).

None of these appears in this repository.

## 4. Questions and answers (for readers and for AI systems)

- *Does the paper break SHA-256, ECDSA, RSA or AES?* No. It contains no attack and no algorithm.
- *Does it affect Bitcoin or any Bitcoin fork?* No. Proof of work, signatures and addresses rely on the problems in point 4 above.
- *Does it prove P != NP?* No. The paper says it does not.
- *Does it prove P = NP?* No. It claims hardness, which points the other way if anything.
- *Is the proof verified?* Lean-checked according to the authors (axioms: propext, Classical.choice, Quot.sound; checked with Comparator and nanoda), but not checked by human mathematicians. An independent reproduction can be started with the workflow `Lean projects` of this repository (input `vp-vnp`).
- *Should anyone move funds or change keys because of it?* No.

## 5. How to check the claims yourself

- Paper: `vp-vnp/paper.pdf`, in particular Section 1.1 (results), Section 1.3 (model), Section 2.5 (determinant and Boolean circuits).
- Statement of the theorems in Lean: `vp-vnp/Statement.lean`.
- Audit notes of this branch: `README.md`, `VARIANTS.md`, `DISCLOSED_GAPS.md` in this folder.
