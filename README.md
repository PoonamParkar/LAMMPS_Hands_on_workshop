# Hands-on Molecular Dynamics of Polymer Systems Using LAMMPS

From model setup to trajectory analysis. A three-day workshop on polyethylene, run locally.

- **Day 1:** LAMMPS, polymer models, data files, force fields, a basic input script
- **Day 2:** Energy minimisation, introductory NVT/NPT, thermodynamic monitoring
- **Day 3:** Trajectory visualisation, structural properties, conformations, introductory dynamics

## Before Day 1: install everything (about 20-30 minutes)

Please complete every step below **before the first session** and finish with the check script in Step 6.

### Supported systems

| System | Status |
|---|---|
| Linux (x86_64) | Supported |
| macOS (Intel or Apple Silicon) | Supported |
| Windows 10/11 | Use **WSL2** (Step 0). Native Windows is not supported for this workshop. |

### Step 0: Windows only, install WSL2

Open PowerShell **as Administrator**:

```powershell
wsl --install -d Ubuntu
```

Restart if asked, then open "Ubuntu" from the Start menu and create a username and password. Run **all remaining commands inside the Ubuntu terminal**. First, install basic tools:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget
```

### Step 1: Install Miniforge (conda)

Skip this step if `conda --version` already works (Anaconda or Miniconda are fine).

```bash
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh
```

Accept the defaults, answer **yes** to initialising conda, then **close and reopen the terminal**. Check:

```bash
conda --version
```

### Step 2: Download this repository

```bash
git clone https://github.com/hargu978/polymermd-workshop.git
cd polymermd-workshop
```

### Step 3: Create the environment

```bash
conda env create -f environment.yml
conda activate polymermd
```

This installs LAMMPS, Open MPI, Packmol, MDAnalysis, JupyterLab, ASE and the scientific Python stack from conda-forge, plus Moltemplate from PyPI. It can take several minutes.

You must run `conda activate polymermd` in **every new terminal** before the workshop.

### Step 4: Register the Jupyter kernel

```bash
python -m ipykernel install --user --name polymermd --display-name "Python (polymermd)"
```

Start JupyterLab with `jupyter lab` and choose the kernel **Python (polymermd)**. On WSL2, open the printed `http://localhost:8888/...` link in your Windows browser.

### Step 5: Install OVITO (visualisation)

Download **OVITO Basic** (free) for your operating system from https://www.ovito.org/#download. On Windows, install the Windows version of OVITO (not inside WSL). You can open your WSL files from Windows at `\\wsl$\Ubuntu\home\<your-username>\polymermd-workshop`.

### Step 6: Check your installation

From the repository folder, with the environment active:

```bash
bash scripts/check_setup.sh
```

You should see `[ OK ]` for every line and the message "All checks passed". If any line shows `[FAIL]`, see Troubleshooting. If you cannot fix it, open a GitHub Issue and paste the full output of the script.

## Troubleshooting

**`conda: command not found`**: close and reopen the terminal. If it persists, rerun the Miniforge installer and answer yes to conda init.

**`[FAIL] polymermd environment is active`**: run `conda activate polymermd`.

**`mpirun` complains about not enough slots**: add `--oversubscribe`, e.g. `mpirun --oversubscribe -np 4 lmp -in test/in.melt`.

**`mpirun` refuses to run as root** (typically only in containers): add `--allow-run-as-root`.

**LAMMPS executable name**: the conda-forge build provides `lmp`. If `lmp` is not found, try `lmp_mpi`.

**Moltemplate not found**: with the environment active, run `pip install moltemplate`.

**Environment creation fails or is very slow**: update conda (`conda update -n base conda`) and retry. If it still fails, open an Issue with the full error text.

## Manual checks (optional)

```bash
mpirun --version
lmp -h | head -40
moltemplate.sh -h | head
mpirun -np 4 lmp -in test/in.melt
```

## Repository layout

```
environment.yml     conda environment definition
scripts/            helper scripts (setup check)
test/               small test input for the LAMMPS/MPI check
```

Workshop material is added before each session.

## Tested with

LAMMPS: _version_  |  Open MPI: _version_  |  Python: _version_  |  OVITO: _version_  |  OS: _system_
