# Branch Coverage vs. Masking MC/DC on Homogeneous Boolean Chains

![Build](https://img.shields.io/badge/build-passing-brightgreen)
![Reproducibility](https://img.shields.io/badge/reproducible-yes-blue)
![Coverage](https://img.shields.io/badge/branch%20coverage-gcov-orange)
![HBC](https://img.shields.io/badge/homogeneous-boolean%20chains-purple)
![MC/DC](https://img.shields.io/badge/MC%2FDC-supported-green)
![License: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)
![Platform](https://img.shields.io/badge/platform-Linux%20x86__64-lightgrey)
![Toolchain](https://img.shields.io/badge/gcc-11.4.0-blue)
![Version](https://img.shields.io/github/v/tag/gaetanovespero81/branch-mcdc-equivalence?label=version)

This repository contains the executable experiments used to demonstrate that, for **homogeneous Boolean chains** (AND-only or OR-only, short-circuited), **branch outcome coverage measured with gcov is equivalent to masking-style MC/DC**.  
The experiments also include a **refactoring case study** showing how a mixed Boolean decision can be rewritten into homogeneous chains so that gcov branch coverage can be reused as MC/DC evidence.

Use this artifact to reproduce the experimental results that support the theoretical analysis presented in the associated manuscript.

---

## 🚀 How to run the experiments

From the root directory:

`./run_all.sh`

This builds all Boolean chain models (2–4 clauses) and executes the canonical MC/DC suites.
Coverage outputs `(*.gcov)` and summaries are saved under `reports/and/` and `reports/or/`.

---

## 🔧 Refactoring case study

Under `refactor_example/`, the original mixed decision:

`(speed > 0 && brake == 0) || (emergency != 0)`

is transformed into homogeneous chains:

`core     = (speed > 0) && (brake == 0);`

`decision = (emergency != 0) || core;`

From the root directory, run the refactoring example with:

`./run_refactor_all.sh`

Reports appear under `reports/refactor/`.

---

## 🏗️ Experimental Environment

All experiments in this artifact were executed using the following toolchain:

- GCC version: 11.4.0
- gcov version: 11.4.0
- Operating system: Ubuntu 22.04.5 LTS (64-bit)
- Kernel: Linux 6.8.0
- Machine architecture: x86_64

### Compilation flags

All programs are compiled using standard GCC coverage instrumentation:

`gcc -O0 -fprofile-arcs -ftest-coverage source.c -o executable`

These flags ensure:

- short-circuit evaluation is preserved
- one branch is emitted for each clause
- gcov reports correspond directly to the abstract execution model
- .gcno/.gcda files match the behavior expected in the experiments

---

## 🔍 Understanding gcov Branch Reporting

Gcov measures **branch outcomes** directly from the program’s control-flow graph (CFG).  
Every conditional generates two possible outgoing edges:

- one edge is taken when the condition evaluates to *true*  
- the other is taken when it evaluates to *false*

For each branch outcome, gcov reports how often that edge was taken relative to the number of times the decision point was executed.  
Example:

```
branch 0 taken 33% (fallthrough)
branch 1 taken 67%
branch 2 taken 0%  (fallthrough)
branch 3 taken 100%
```

This means:
- **taken 33%** → the branch was taken in 33% of the evaluations
- **taken 67%** → the branch was taken in 67% of the evaluations
- **taken 0%** → the branch was never taken
- **taken 100%** → this branch was taken every time the decision was evaluated

Importantly:
- gcov does **not** report “branch coverage” in the sense used in textbooks or safety standards
- it reports **branch-outcome execution frequencies** at the CFG level
- we only care whether a branch outcome was taken **at least once**

Therefore, in this artifact a branch outcome is considered:
- **covered** if taken > 0%
- **not covered** if taken = 0%

For homogeneous Boolean chains, each branch outcome in the CFG corresponds exactly to one **canonical behavioral class** of the chain.
This alignment is what allows branch-outcome coverage to be used as an indicator of behavioral-class coverage.

### 📊 Interpreting “Taken at least once: X% of Y” (summary.txt)

Each experiment produces a `summary.txt` file containing a line such as:

`Taken at least once: 75.00% of 4`

This metric is computed directly from gcov’s branch-outcome data:
- **Y** = the total number of branch outcomes produced by the Boolean decision
(e.g., a 2-clause AND or OR chain produces 4 outcomes)
- **X%** = the percentage of those outcomes for which gcov reports taken > 0%
— meaning that each such branch was executed **at least once** across all test inputs in the suite

Example:

`Taken at least once: 75.00% of 4`

means:
- the decision has **4** possible branch outcomes,
- **3** were taken at least once,
- **1** was never taken (taken = 0%).

For homogeneous Boolean chains, these branch outcomes correspond **one-to-one** with the chain’s canonical behavioral classes (K₀, K₁, …).
Thus:
- **75% coverage ⇒ exactly one behavioral class is missing**
- **100% coverage ⇒ all behavioral classes exercised ⇒ masking-style MC/DC satisfied**

This percentage is therefore used throughout the artifact to determine whether a test suite fully covers the behavioral space of the Boolean chain.

### 🔎 Why this metric matters

The value _“Taken at least once: X% of Y”_ is the exact notion of branch-outcome coverage used in the experiments.
For homogeneous Boolean chains, exercising every branch outcome once is equivalent to exercising every behavioral class once.
This makes gcov’s branch-outcome information a direct indicator of masking-style MC/DC for this specific family of Boolean expressions.

---

## 📄 Outputs

Each experiment produces under `reports/and/` and `reports/or/`:

- .gcov file showing branch executions
- A summary of branch coverage for each canonical-class subset
- Evidence showing that:
  -  Missing one canonical class → branch coverage is incomplete
  - One test per canonical class → full branch coverage + MC/DC

The refactoring example shows a case where:

- Two semantically equivalent decisions
- Have different MC/DC requirements
- But after refactoring into homogeneous chains, **branch coverage = MC/DC**, confirming the theory

---

## 📘 License

MIT License © 2025 Gaetano Vespero
See LICENSE for details.

---

## 📝 Citation

If this artifact is useful in your research or tooling work, please consider citing the associated paper once available.
