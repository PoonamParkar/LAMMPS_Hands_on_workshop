# Hands-on Molecular Dynamics of Polymer Systems Using LAMMPS

From model setup to trajectory analysis. A three-day workshop on polymer.

* **Day 1:** LAMMPS, polymer models, data files, force fields, a basic input script
* **Day 2:** Energy minimisation, introductory NVT/NPT, thermodynamic monitoring
* **Day 3:** Trajectory visualisation, structural properties, conformations, introductory dynamics

## Installation 



### Supported systems

|System|Status|
|-|-|
|Windows 10/11|Use **WSL2 with Ubuntu 24.04** (Step 0). Native Windows is not supported.|
|Linux (x86\_64)|Supported. Needs glibc 2.38 or newer (for example Ubuntu 24.04 or later).|
|macOS (Intel or Apple Silicon)|Supported.|

> \*\*Important:\*\* Older Ubuntu versions (such as 22.04) fail with the error `GLIBC\_2.38 not found`. Use Ubuntu 24.04.

### How to tell which terminal you are in

* **PowerShell** (Windows): the prompt looks like `PS C:\\Users\\...>`. Used only for the `wsl` commands in Step 0.
* **Ubuntu terminal**: the prompt looks like `yourname@COMPUTERNAME:\~$`. Used for every other command in this guide.

Type only the commands inside the grey code boxes. Do not type the triple backticks.

### Step 0: Windows only, install WSL2 with Ubuntu 24.04

Open **PowerShell as Administrator** (right-click Start, then choose Terminal (Admin) or PowerShell (Admin)):

```powershell
wsl --install -d Ubuntu-24.04
```

Restart if asked. Then open **Ubuntu 24.04** from the Start menu and create a username and password. Nothing appears on screen while you type the password, which is normal.

If more than one Ubuntu is installed, open the right one from PowerShell with:

```powershell
wsl -d Ubuntu-24.04
```

Run **all remaining commands inside the Ubuntu terminal**. Check the Ubuntu version (the last line should show 2.39):

```bash
ldd --version | head -1
```

Update Ubuntu and install basic tools:

```bash
sudo apt update  

sudo apt upgrade -y
sudo apt install -y git curl wget
```

### Step 1: Install Miniforge (conda)

Miniforge is a small, free conda installer that uses the conda-forge channel, where this workshop's software (LAMMPS, Packmol, MDAnalysis) is distributed.

Skip this step if `conda --version` already works. If you already have Anaconda or Miniconda, see the note in Step 3.

```bash
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh
```

In the installer:

1. Press **ENTER** and keep pressing it (or the space bar) to scroll through the license.
2. Type `yes` to accept the license.
3. Press **ENTER** to accept the default install location.
4. Type `yes` when asked whether to initialise conda.

Then **close the terminal completely and open it again**. Check:

```bash
conda --version
which conda
```

`which conda` should show a path containing `miniforge3`, and the prompt should start with `(base)`.

If you see `conda: command not found`, run the following, then close and reopen the terminal and check again:

```bash
~/miniforge3/bin/conda init bash
```

### Step 2: Download this repository

```bash
git clone https://github.com/PoonamParkar/LAMMPS_Hands_on_workshop.git
cd LAMMPS_Hands_on_workshop
```

**If `git clone` asks for a username or password**, do not enter one. Press Ctrl+C and use the ZIP download instead:

1. Open https://github.com/PoonamParkar/LAMMPS_Hands_on_workshop in your browser.
2. Click the green **Code** button, then **Download ZIP**.
3. Unzip it and copy the folder into your Ubuntu home folder. On Windows, open `\\\\wsl$\\Ubuntu-24.04\\home\\<your-username>` in File Explorer and paste the folder there.
4. In the Ubuntu terminal, go into the folder. Check its exact name first:

```bash
   ls 
   cd /LAMMPS_Hands_on_workshop-main
   ```

Keep the workshop folder **inside the Ubuntu home folder** (`/home/<your-username>`), not under `/mnt/c/...`. Files on the Windows drive run much slower in WSL.

### Step 3: Create the environment

Make sure you are inside the repository folder (the one that contains `environment.yml`):

```bash
ls environment.yml
```

Then:

```bash
conda env create -f environment.yml
conda activate polymermd
```

This installs LAMMPS, Open MPI, Packmol, MDAnalysis, JupyterLab, ASE and the scientific Python stack from conda-forge, plus Moltemplate from PyPI. It can take several minutes.

Your prompt should now start with `(polymermd)`. You must run `conda activate polymermd` in **every new terminal** before using the workshop tools. To leave the environment, run `conda deactivate`.

**Note for existing Anaconda or Miniconda users:** to avoid mixing channels, create the environment with conda-forge only:

```bash
conda env create -f environment.yml --override-channels -c conda-forge
```

### Step 4: Register the Jupyter kernel

JupyterLab and ipykernel are already installed by Step 3. Make sure your prompt starts with `(polymermd)` (if not, run `conda activate polymermd`), then:

```bash
python -m ipykernel install --user --name polymermd --display-name "Python (polymermd)"
```

Start JupyterLab from the repository folder:

```bash
jupyter lab
```

A browser may not open automatically. Copy the `http://localhost:8888/...` link (including the `token=` part) from the terminal and paste it into your Windows browser. In JupyterLab, choose the kernel **Python (polymermd)**.

Notes:

* Keep the Ubuntu terminal open while JupyterLab runs. Press **Ctrl+C** in that terminal to stop it.
* Messages such as "Skipped non-installed server(s)" can be ignored.
* If you need to run other commands while JupyterLab is running, open a second Ubuntu terminal and run `conda activate polymermd` there.
* If the link does not load, try `127.0.0.1` instead of `localhost`, and use the port number printed in the terminal.

### Step 5: Install OVITO (visualisation)

Download **OVITO Basic** (free) for your operating system from https://www.ovito.org/#download. 

### Step 6: Check your installation

From the repository folder, with the environment active (`(polymermd)` in the prompt):

```bash
bash check\_setup.sh
```

You should see `\[ OK ]` on every line and the message "All checks passed". If any line shows `\[FAIL]`, see Troubleshooting. If you cannot fix it, open a GitHub Issue and paste the full output of the script.

## Troubleshooting

**`conda: command not found`**: close and reopen the terminal. If it persists, run `\~/miniforge3/bin/conda init bash` and reopen the terminal again.

**`\[FAIL] polymermd environment is active`**: run `conda activate polymermd`.

**`GLIBC\_2.38 not found` when running LAMMPS**: your Ubuntu is too old. Install Ubuntu 24.04 (Step 0).

**`git clone` asks for a password**: use the ZIP download in Step 2.

**`E: The update command takes no arguments`** (or similar errors with `\\\&\\\&`): you copied stray backslashes. Type the command by hand, or run `sudo apt update` and `sudo apt upgrade -y` as two separate commands.

**`No module named ipykernel`**: the environment is not active. Run `conda activate polymermd`.

**`mpirun` complains about not enough slots**: add `--oversubscribe`, for example `mpirun --oversubscribe -np 4 lmp -in test/in.melt`.

**`mpirun` refuses to run as root** (typically only in containers): add `--allow-run-as-root`.

**LAMMPS executable name**: the conda-forge build provides `lmp`. If `lmp` is not found, try `lmp\_mpi`.

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
environment.yml      conda environment definition
scripts/             helper scripts (setup check)
test/                small test input for the LAMMPS/MPI check
```

## Tested with

Ubuntu 24.04 (WSL2) | LAMMPS: *version* | Open MPI: *version* | Python: *version* | OVITO: *version*

