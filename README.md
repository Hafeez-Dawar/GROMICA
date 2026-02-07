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

<div class="installation-methods">

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
</div>
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

## 📖 Detailed Usage

### Single Trajectory Analysis

#### 1. RMSD Analysis

**Root Mean Square Deviation - measures structural stability**

```r
library(GROMICA)

# Read RMSD file
rmsd_data <- read_xvg("rmsd1.xvg")
> rmsd_data
         Time     Value
1   0.0000000 0.0004979
2   0.0100000 0.1224554
3   0.0200000 0.1739694
4   0.0300000 0.2117630
5   0.0400000 0.2239067
6   0.0500000 0.2338255
7   0.0600000 0.2414166
8   0.0700000 0.2331374
9   0.0800000 0.2567547
10  0.0900000 0.2787587
11  0.1000000 0.2925077
12  0.1100000 0.2988492
13  0.1200000 0.3192437
14  0.1300000 0.3206752
[ reached 'max' / getOption("max.print") -- omitted 19501 rows ]

# Create rmsd plot
p <- plot_rmsd(rmsd_data, 
               color = "chartreuse", 
               title = "RMSD Plot")
print(p)
# Export high-resolution figure
export_plot(p, "rmsd_analysis.png", dpi = 600, width = 8, height = 6)

![RMSD Plot](https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/rmsd1.png)

# Create plot with statistics overlay
p <- plot_rmsd(rmsd_data, 
               color = "violetred", 
               title = "RMSD Plot",
               show_stats = TRUE)
print(p)
# Export high-resolution figure
export_plot(p, "rmsd_analysis.png", dpi = 600, width = 8, height = 6)

![RMSD with Statistics](https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/rmsd1-with-stats.png)

**Interpretation:**
- **Low RMSD (0.1-0.2 nm):** Protein is stable
- **High RMSD (>0.5 nm):** Significant structural changes
- **Plateau in RMSD:** System has equilibrated

---

#### 2. RMSF Analysis

**Root Mean Square Fluctuation - measures residue flexibility**

```r

# Read RMSF file
rmsf_data <- read_xvg("rmsf1.xvg")
> rmsf_data
    Time  Value
1      1 0.4061
2      2 0.2206
3      3 0.1622
4      4 0.1783
5      5 0.1922
6      6 0.1665
7      7 0.1508
8      8 0.1825
9      9 0.1931
10    10 0.1650
11    11 0.1632
12    12 0.1987
13    13 0.2044
14    14 0.1826
15    15 0.1969
[ reached 'max' / getOption("max.print") -- omitted 81 rows ]
> 
# Create RMSF plot
p <- plot_rmsf(rmsf_data, 
               color = "darkorchid", 
               title = "RMSF Plot")
print(p)
# Export
export_plot(p, "rmsf_analysis.png", dpi = 600, width = 10, height = 6)

![RMSF Plot](https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/rmsf1.png)

**Interpretation:**
- **High RMSF peaks:** Flexible regions (loops, termini)
- **Low RMSF:** Rigid regions (secondary structures)
- **Consistent RMSF:** Uniform flexibility

---

#### 3. Radius of Gyration (Rg)

**Measures protein compactness**

```r

# Read Rg file
rg_data <- read_xvg("gyrate1.xvg")
> rg_data
      V1       V2       V3       V4       V5
1   0.00 2.922417 2.499337 2.597192 2.022110
2   0.01 2.952003 2.538245 2.611072 2.041636
3   0.02 2.932107 2.520864 2.592119 2.029942
4   0.03 2.935646 2.544368 2.598690 2.002252
5   0.04 2.938521 2.547938 2.598583 2.006290
6   0.05 2.936497 2.539021 2.598356 2.011953
7   0.06 2.925918 2.525828 2.587912 2.011195
8   0.07 2.937822 2.543977 2.602533 2.004152
9   0.08 2.936489 2.544966 2.600713 2.001342
10  0.09 2.945027 2.556910 2.605893 2.004470
11  0.10 2.942256 2.548854 2.590209 2.026796
12  0.11 2.918044 2.530169 2.561202 2.017047
13  0.12 2.930127 2.534340 2.572105 2.032897
14  0.13 2.919782 2.533250 2.556755 2.023830
15  0.14 2.897957 2.507852 2.531953 2.023906
16  0.15 2.895889 2.498101 2.522651 2.041586
17  0.16 2.907824 2.503615 2.541262 2.045669
[ reached 'max' / getOption("max.print") -- omitted 19801 rows ]

# Create Rg plot
p <- plot_rg(rg_data, 
             color = "yellow3", 
             title = "Radius of Gyration",
             )
print(p)

# Export
export_plot(p, "rg_analysis.png", dpi = 600, width = 8, height = 6)

![Radius of Gyration](https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/Rg1.png)

**Interpretation:**
- **Stable Rg:** Protein maintains compact structure
- **Increasing Rg:** Protein is unfolding
- **Decreasing Rg:** Protein is becoming more compact

---

#### 4. SASA Analysis

**Solvent Accessible Surface Area - measures surface exposure**

```r

# Read SASA file
sasa_data <- read_xvg("sasa1.xvg")
> sasa_data
    Time   Value
1   0.00 376.562
2   0.01 370.830
3   0.02 366.824
4   0.03 364.864
5   0.04 366.340
6   0.05 370.263
7   0.06 367.899
8   0.07 364.968
9   0.08 363.425
10  0.09 363.553
11  0.10 362.314
12  0.11 366.860
13  0.12 360.956
14  0.13 362.936
15  0.14 358.481
16  0.15 364.645
17  0.16 362.572
18  0.17 360.293
[ reached 'max' / getOption("max.print") -- omitted 19501 rows ]

# Create SASA plot
p <- plot_sasa(sasa_data, 
               color = "purple", 
               title = "Surface Accessibility",
               )
print(p)

# Export
export_plot(p, "sasa_analysis.png", dpi = 600, width = 8, height = 6)

![SASA Plot](https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/sasa1.png)

**Interpretation:**
- **Stable SASA:** Consistent surface exposure
- **Increasing SASA:** More residues exposed to solvent
- **Decreasing SASA:** Protein becoming more buried

---

#### 5. Hydrogen Bond Analysis

**Measures internal hydrogen bonding**

```r
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
```

**Interpretation:**
- **Stable H-bonds:** Protein maintains secondary structure
- **Decreasing H-bonds:** Structure destabilization
- **Fluctuating H-bonds:** Dynamic conformational changes

---

### Multi-Trajectory Comparison

#### (1) RMSD

```r
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

![Multi RMSD](https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/RMSD1%2B2%2B3.png)

---

#### Compare Multiple Trajectories of RMSF

```r

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

![Multi RMSF](https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/rmsf1%2B2%2B3.png)

#### Compare Multiple Trajectories of SASA

```r

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

![Multi SASA](https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/sasa1%2B2%2B3%2B4.png)

#### Compare Multiple Trajectories of SASA

```r

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

![Multi Rg](https://raw.githubusercontent.com/Hafeez-Dawar/GROMICA/refs/heads/main/images/gyrate1%2B2%2B3.png)

# ═══════════════════════════════════════════════════════
#   BATCH PROCESSING - ANALYZE MULTIPLE SIMULATIONS (e.g; RMSD)
# ═══════════════════════════════════════════════════════

library(GROMICA)

# Get all RMSD files in directory
files <- list.files(pattern = "*_rmsd.xvg", full.names = TRUE)

cat("Processing", length(files), "RMSD files...\n\n")

# Process each file
for (file in files) {
  # Extract protein name
  name <- gsub("_rmsd.xvg", "", basename(file))
  
  # Read and plot
  data <- read_xvg(file)
  p <- plot_rmsd(data, 
                 color = "blue", 
                 title = paste(name, "- RMSD Analysis"),
                 show_stats = TRUE)
  
  # Save
  output <- paste0("rmsd_", name, ".png")
  export_plot(p, output, dpi = 600)
  
  cat("✓ Processed:", name, "\n")
}

cat("\n✅ All", length(files), "files processed!\n")
```

---

## 📖 Function Reference

### read_xvg()

**Import GROMACS XVG files**

```r
read_xvg(file, skip = NULL, col.names = NULL)
```

**Parameters:**
- `file`: Path to XVG file
- `skip`: Number of header lines to skip (auto-detected)
- `col.names`: Column names (auto-generated if NULL)

**Returns:** data.frame with Time and Value columns

**Example:**
```r
data <- read_xvg("md_rmsd.xvg")
data <- read_xvg("rmsf.xvg", col.names = c("Residue", "RMSF"))
```

---

### compare_trajectories()

**Compare multiple trajectories on one plot**

```r
compare_trajectories(files, labels = NULL, colors = NULL, 
                     analysis_type = "rmsd", title = NULL, 
                     xlab = NULL, ylab = NULL, 
                     linewidth = 1, legend_position = "right")
```

**Parameters:**
- `files`: Character vector of 2-10 XVG file paths
- `labels`: Labels for each trajectory
- `colors`: Colors for each line
- `analysis_type`: Type of analysis ("rmsd", "rmsf", "rg", "sasa", "hbond")
- `title`: Plot title (auto-generated if NULL)
- `xlab`: X-axis label (auto-generated)
- `ylab`: Y-axis label (auto-generated)
- `linewidth`: Line width (default: 1)
- `legend_position`: Legend position ("right", "left", "top", "bottom", "none")

**Returns:** ggplot2 object with all trajectories

**Example:**
```r
files <- c("wt.xvg", "mut1.xvg", "mut2.xvg")
p <- compare_trajectories(
  files = files,
  labels = c("WT", "Mut1", "Mut2"),
  colors = c("black", "red", "blue"),
  analysis_type = "rmsd"
)
```

### Plotting Issues

**Problem:** Plot doesn't appear

**Solution:** Explicitly print the plot:
```r
p <- plot_rmsd(data)
print(p)  # This displays it
```

---

**Problem:** Plot quality is poor

**Solution:** Use higher DPI:
```r
export_plot(p, "plot.png", dpi = 1200)  # Maximum quality
```

---

### Comparison Issues

**Problem:** `Number of colors must match number of files`

**Solution:** Provide correct number of colors or omit colors parameter:
```r
# Auto colors (easiest)
compare_trajectories(files, labels = c("A", "B"))

# Or specify all colors
compare_trajectories(files, labels = c("A", "B"), colors = c("blue", "red"))
```

---

## 📊 Best Practices

### For Publication-Quality Figures

```r
# Use high DPI
export_plot(p, "figure.png", dpi = 1200, width = 8, height = 6)

# Use PDF for infinite resolution
export_plot(p, "figure.pdf", width = 8, height = 6)

# Use consistent colors
colors <- c("black", "red", "blue", "green")  # Define once, use everywhere

### For Reproducible Research

```r
# Always set working directory explicitly
setwd("/full/path/to/project")

# Save session info
sessionInfo()

# Document package version
packageVersion("GROMICA")
```

---

## 📄 Citation

If you use GROMICA in your research, please cite:

```
Rehman, H. U. (2025). GROMICA: The Art of MD Simulation Visualization. 
R package version 1.0.1. 
https://github.com/hafeez-dawar/GROMICA
```

**BibTeX:**
```bibtex
@software{gromica2025,
  author = {Rehman, Hafeez Ur},
  title = {GROMICA: The Art of MD Simulation Visualization},
  year = {2025},
  publisher = {GitHub},
  url = {https://github.com/hafeez-dawar/GROMICA},
  version = {1.0.1}
}
```

---

## 📧 Support

- **Email:** hafeez@nwafu.edu.cn
- **Documentation:** https://github.com/hafeez-dawar/GROMICA

---

## 📜 License

This project is licensed under the GPL-3.0 License - see the [LICENSE.md](LICENSE.md) file for details.

---

## 🙏 Acknowledgments

- GROMACS team for molecular dynamics software
- R community for ggplot2 and related packages
- All contributors and users of GROMICA

---

## 📈 Version History

### Version 1.0.1 (2025-01-25)
- Initial release
- 8 core functions for MD analysis
- Single and multi-trajectory support
- Publication-quality export (up to 1200 DPI)
- Comprehensive documentation

---

**Made with great efforts for the computational biologist and chemist**
