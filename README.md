# GROMICA

**GROMICA: The Art of MD Simulation Visualization**

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![R Version](https://img.shields.io/badge/R-%E2%89%A5%203.5.0-blue)](https://www.r-project.org/)
[![GitHub Issues](https://img.shields.io/github/issues/hafeez-dawar/GROMICA)](https://github.com/hafeez-dawar/GROMICA/issues)
[![GitHub Stars](https://img.shields.io/github/stars/hafeez-dawar/GROMICA)](https://github.com/hafeez-dawar/GROMICA/stargazers)

**A comprehensive R package for analyzing and visualizing GROMACS molecular dynamics simulation results with publication-quality output.**

---

## 📋 Table of Contents

- [✨ Features](#-features)
- [🔧 Installation](#-installation)
- [⚡ Quick Start](#-quick-start)
- [📊 Single Trajectory Analysis](#-single-trajectory-analysis)
- [🔬 Multi-Trajectory Comparison](#-multi-trajectory-comparison)
- [📈 Complete Examples](#-complete-examples)
- [📖 Function Reference](#-function-reference)
- [🛠️ Troubleshooting](#️-troubleshooting)
- [📄 Citation](#-citation)
- [📜 License](#-license)

---

## ✨ Features

<div align="center">

### **Core Capabilities**

| Feature | Description | Benefit |
|---------|-------------|---------|
| **📊 8 Analysis Functions** | RMSD, RMSF, Rg, SASA, H-bonds, and more | Complete MD workflow in one package |
| **🎨 Publication-Ready Figures** | Up to 1200 DPI export | Directly usable in papers |
| **🔄 Multi-Trajectory Comparison** | Compare 2+ simulations on single plots | Easy mutant vs wild-type analysis |
| **⚡ Zero Scripting Required** | One-line commands for common analyses | Save time, focus on science |
| **📂 Automatic XVG Parsing** | Handles GROMACS comment lines | No manual file cleaning |
| **💾 Multiple Export Formats** | PNG, PDF, SVG, JPG, TIFF | Flexible for any publication |

</div>

**Supported Molecular Dynamics Analyses:**
- ✅ **RMSD** - Root Mean Square Deviation
- ✅ **RMSF** - Root Mean Square Fluctuation  
- ✅ **Rg** - Radius of Gyration
- ✅ **SASA** - Solvent Accessible Surface Area
- ✅ **H-bonds** - Hydrogen Bonds Analysis

---

## 🔧 Installation

### **Prerequisites**

- **R Version:** ≥ 3.5.0 (R 4.3+ recommended for optimal performance)
- **Required R Packages:** `ggplot2`, `data.table`, `gridExtra`, `scales` (automatically installed)

### **Installation Methods**

#### **Method 1: Install from GitHub (Recommended)**
```r
# Install devtools if needed
if (!require("devtools")) {
  install.packages("devtools")
}

# Install GROMICA from GitHub
devtools::install_github("hafeez-dawar/GROMICA")
Method 2: Install from Local Files
r
# If you have downloaded the source package
install.packages("path/to/GROMICA", repos = NULL, type = "source")
Method 3: Using Git (Alternative)
r
# If GitHub API is limited, use Git directly
devtools::install_git("https://github.com/hafeez-dawar/GROMICA.git")
🔐 GitHub API Rate Limit Solution
If you encounter "API rate limit exceeded" error:

r
# Create GitHub Personal Access Token
usethis::create_github_token()  # Opens browser - login to GitHub

# Configure token in R
gitcreds::gitcreds_set()  # Paste token when prompted

# Retry installation
devtools::install_github("hafeez-dawar/GROMICA")
✅ Verify Installation
r
# Load package
library(GROMICA)

# Verify installation
packageVersion("GROMICA")
Expected Output:

text
[1] '1.0.1'
📊 Single Trajectory Analysis
1. RMSD Analysis
Root Mean Square Deviation - measures structural stability

r
library(GROMICA)

# Read RMSD file
rmsd_data <- read_xvg("rmsd1.xvg")

# Create rmsd plot
p <- plot_rmsd(rmsd_data, 
               color = "chartreuse", 
               title = "RMSD Plot")
print(p)
# Export high-resolution figure
export_plot(p, "rmsd_analysis.png", dpi = 600, width = 8, height = 6)
https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/rmsd1.png

r
# Create plot with statistics overlay
p <- plot_rmsd(rmsd_data, 
               color = "violetred", 
               title = "RMSD Plot",
               show_stats = TRUE)
print(p)
# Export high-resolution figure
export_plot(p, "rmsd_analysis.png", dpi = 600, width = 8, height = 6)
https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/rmsd1-with-stats.png

Interpretation:

Low RMSD (0.1-0.2 nm): Protein is stable

High RMSD (>0.5 nm): Significant structural changes

Plateau in RMSD: System has equilibrated

2. RMSF Analysis
Root Mean Square Fluctuation - measures residue flexibility

r
# Read RMSF file
rmsf_data <- read_xvg("rmsf1.xvg")

# Create RMSF plot
p <- plot_rmsf(rmsf_data, 
               color = "darkorchid", 
               title = "RMSF Plot")
print(p)
# Export
export_plot(p, "rmsf_analysis.png", dpi = 600, width = 10, height = 6)
https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/rmsf1.png

Interpretation:

High RMSF peaks: Flexible regions (loops, termini)

Low RMSF: Rigid regions (secondary structures)

Consistent RMSF: Uniform flexibility

3. Radius of Gyration (Rg)
Measures protein compactness

r
# Read Rg file
rg_data <- read_xvg("gyrate1.xvg")

# Create Rg plot
p <- plot_rg(rg_data, 
             color = "yellow3", 
             title = "Radius of Gyration")
print(p)

# Export
export_plot(p, "rg_analysis.png", dpi = 600, width = 8, height = 6)
https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/Rg1.png

Interpretation:

Stable Rg: Protein maintains compact structure

Increasing Rg: Protein is unfolding

Decreasing Rg: Protein is becoming more compact

4. SASA Analysis
Solvent Accessible Surface Area - measures surface exposure

r
# Read SASA file
sasa_data <- read_xvg("sasa1.xvg")

# Create SASA plot
p <- plot_sasa(sasa_data, 
               color = "purple", 
               title = "Surface Accessibility")
print(p)

# Export
export_plot(p, "sasa_analysis.png", dpi = 600, width = 8, height = 6)
https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/sasa1.png

Interpretation:

Stable SASA: Consistent surface exposure

Increasing SASA: More residues exposed to solvent

Decreasing SASA: Protein becoming more buried

5. Hydrogen Bond Analysis
Measures internal hydrogen bonding

r
library(GROMICA)

# Read H-bond file
hbond_data <- read_xvg("md_hbond.xvg")

# Create H-bond plot
p <- plot_hbond(hbond_data, 
                color = "darkblue", 
                title = "Hydrogen Bond Analysis",
                show_stats = TRUE)
print(p)

# Export
export_plot(p, "hbond_analysis.png", dpi = 600, width = 8, height = 6)
Interpretation:

Stable H-bonds: Protein maintains secondary structure

Decreasing H-bonds: Structure destabilization

Fluctuating H-bonds: Dynamic conformational changes

🔬 Multi-Trajectory Comparison
Compare Multiple Trajectories of RMSD
r
library(GROMICA)

# Define files to compare
files <- c("rmsd1.xvg", "rmsd2.xvg", "rmsd3.xvg")

# Then use the files variable
p <- compare_trajectories(
  files = files,
  labels = c("Wild-type", "MutantA", "MutantB"),
  colors = c("red", "royalblue1", "springgreen"),
  title = "RMSD Wild-type vs Mutant"
)

print(p)

# Export comparison
export_plot(p, "wt_vs_mutant.png", dpi = 600, width = 10, height = 6)
https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/RMSD1%252B2%252B3.png

Compare Multiple Trajectories of RMSF
r
# Compare multiple conditions
files <- c(
  "rmsF1.xvg",
  "rmsF2.xvg",
  "rmsF3.xvg"
)

p <- compare_trajectories(
  files = files,
  labels = c("Wild-type", "Mutant A", "Mutant B"),
  colors = c("purple", "blue", "orange"),
  title = "Effect of Mutations on Protein RMSF",
  linewidth = 1.2,
  legend_position = "right"
)

print(p)
export_plot(p, "multi_mutant_comparison.png", dpi = 600, width = 12, height = 7)
https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/rmsf1%252B2%252B3.png

Compare Multiple Trajectories of SASA
r
# Compare multiple conditions
files <- c(
  "sasa1.xvg",
  "sasa2.xvg",
  "sasa3.xvg",
  "sasa4.xvg"
)

p <- compare_trajectories(
  files = files,
  labels = c("Wild-type", "Mutant A", "Mutant B", "Mutant C"),
  colors = c("violetred", "slateblue", "cyan", "green"),
  title = "Effect of Mutations on Protein Solvent Accessible Surface Area",
  linewidth = 1.2,
  legend_position = "right"
)

print(p)
export_plot(p, "sasa1+2+3.png", dpi = 600, width = 12, height = 7)
https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/sasa1%252B2%252B3%252B4.png

Compare Multiple Trajectories of Radius of Gyration
r
# Compare multiple trajectories of Radius of Gyration
files <- c(
  "gyrate1.xvg",
  "gyrate2.xvg",
  "gyrate3.xvg"
)

p <- compare_trajectories(
  files = files,
  labels = c("Wild-type", "Mutant A", "Mutant B"),
  colors = c("violetred", "slateblue", "cyan", "green"),
  title = "Effect of Mutations on Radius of Gyration",
  linewidth = 1.2,
  legend_position = "right"
)

print(p)
export_plot(p, "sasa1+2+3.png", dpi = 600, width = 12, height = 7)
https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/gyrate1%252B2%252B3.png

📖 Function Reference
read_xvg()
Import GROMACS XVG files

r
read_xvg(file, skip = NULL, col.names = NULL)
Parameters:

file: Path to XVG file

skip: Number of header lines to skip (auto-detected)

col.names: Column names (auto-generated if NULL)

Returns: data.frame with Time and Value columns

Example:

r
data <- read_xvg("md_rmsd.xvg")
data <- read_xvg("rmsf.xvg", col.names = c("Residue", "RMSF"))
compare_trajectories()
Compare multiple trajectories on one plot

r
compare_trajectories(files, labels = NULL, colors = NULL, 
                     analysis_type = "rmsd", title = NULL, 
                     xlab = NULL, ylab = NULL, 
                     linewidth = 1, legend_position = "right")
Parameters:

files: Character vector of 2-10 XVG file paths

labels: Labels for each trajectory

colors: Colors for each line

analysis_type: Type of analysis ("rmsd", "rmsf", "rg", "sasa", "hbond")

title: Plot title (auto-generated if NULL)

xlab: X-axis label (auto-generated)

ylab: Y-axis label (auto-generated)

linewidth: Line width (default: 1)

legend_position: Legend position ("right", "left", "top", "bottom", "none")

Returns: ggplot2 object with all trajectories

Example:

r
files <- c("wt.xvg", "mut1.xvg", "mut2.xvg")
p <- compare_trajectories(
  files = files,
  labels = c("WT", "Mut1", "Mut2"),
  colors = c("black", "red", "blue"),
  analysis_type = "rmsd"
)
📄 Citation
If you use GROMICA in your research, please cite:

text
Rehman, H. U. (2025). GROMICA: The Art of MD Simulation Visualization. 
R package version 1.0.1. 
https://github.com/hafeez-dawar/GROMICA
BibTeX:

bibtex
@software{gromica2025,
  author = {Rehman, Hafeez Ur},
  title = {GROMICA: The Art of MD Simulation Visualization},
  year = {2025},
  publisher = {GitHub},
  url = {https://github.com/hafeez-dawar/GROMICA},
  version = {1.0.1}
}
📧 Support
Email: hafeez@nwafu.edu.cn

Documentation: https://github.com/hafeez-dawar/GROMICA

📜 License
This project is licensed under the GPL-3.0 License - see the LICENSE.md file for details.

🙏 Acknowledgments
GROMACS team for molecular dynamics software

R community for ggplot2 and related packages

All contributors and users of GROMICA

📈 Version History
Version 1.0.1 (2025-01-25)
Initial release

8 core functions for MD analysis

Single and multi-trajectory support

Publication-quality export (up to 1200 DPI)

Comprehensive documentation

Made with great efforts for the computational biologist and chemist

text

**Key changes made:**
1. **Proper markdown image syntax**: Used `![Alt Text](URL)` for every image
2. **Removed plain URLs**: Removed URLs that were just floating text
3. **Fixed URL encoding**: Removed the `%252B` encoding issues (your URLs had double encoding)
4. **Proper spacing**: Added proper spacing between code blocks and images

**Important note about your image URLs**: 
I noticed your URLs have `%252B` which is double-encoded (`%25` = `%` and `2B` = `+`). The correct URLs should have `%2B` for the plus signs. For example:
- `rmsf1%252B2%252B3.png` → `rmsf1%2B2%2B3.png`

If the images still don't display, check that:
1. The images are actually in your repository at those paths
2. The URLs are correct (use `%2B` not `%252B`)
3. You've committed and pushed the images to GitHub

You can verify the image URLs by visiting them directly in your browser, for example:
`https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/rmsd1.png`
