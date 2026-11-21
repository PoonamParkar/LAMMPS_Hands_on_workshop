#!/usr/bin/env bash
# Run from the repository root with the polymermd environment active:
#   conda activate polymermd
#   bash scripts/check_setup.sh
fail=0
ok()   { echo "[ OK ] $1"; }
bad()  { echo "[FAIL] $1"; fail=1; }
check(){ if eval "$2" >/dev/null 2>&1; then ok "$1"; else bad "$1"; fi; }

LMP=$(command -v lmp || command -v lmp_mpi || true)

check "polymermd environment is active" '[ "${CONDA_DEFAULT_ENV:-}" = "polymermd" ]'
check "Python can import MDAnalysis, numpy, scipy, pandas, matplotlib, ase" \
      'python -c "import MDAnalysis, numpy, scipy, pandas, matplotlib, ase"'
check "JupyterLab is installed" 'jupyter lab --version'
check "mpirun is available" 'command -v mpirun'
check "LAMMPS executable found (lmp or lmp_mpi)" '[ -n "$LMP" ]'
if [ -n "$LMP" ]; then
  check "LAMMPS has the MOLECULE package" "$LMP -h | grep -q MOLECULE"
  check "LAMMPS has the KSPACE package"   "$LMP -h | grep -q KSPACE"
  check "LAMMPS serial test run"          "$LMP -in test/in.melt -log none"
  export OMPI_MCA_rmaps_base_oversubscribe=1
  check "LAMMPS parallel test run (2 MPI ranks)" "mpirun -np 2 $LMP -in test/in.melt -log none"
fi
check "Packmol is available" 'command -v packmol'
check "Moltemplate is available" 'command -v moltemplate.sh'

echo
if [ $fail -eq 0 ]; then echo "All checks passed. You are ready for Day 1."
else echo "Some checks failed. See the Troubleshooting section of README.md."; fi
exit $fail
