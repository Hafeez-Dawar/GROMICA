# GROMICA

**GROMACS Molecular Dynamics Interactive Computational Analysis**

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![R Version](https://img.shields.io/badge/R-%E2%89%A5%203.5.0-blue)](https://www.r-project.org/)

A comprehensive R package for analyzing and visualizing GROMACS molecular dynamics simulation results with publication-quality output.

---

## 📋 Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Detailed Usage](#detailed-usage)
  - [Single Trajectory Analysis](#single-trajectory-analysis)
  - [Multi-Trajectory Comparison](#multi-trajectory-comparison)
- [Complete Examples](#complete-examples)
- [Function Reference](#function-reference)
- [Troubleshooting](#troubleshooting)
- [Citation](#citation)
- [License](#license)

---

## ✨ Features

- **8 Core Functions** for comprehensive MD analysis
- **Publication-Ready Figures** (up to 1200 DPI)
- **Multi-Trajectory Comparison** on single plots
- **Zero Scripting Required** for common analyses
- **Automatic XVG Parsing** (handles GROMACS comment lines)
- **Multiple Export Formats** (PNG, PDF, SVG, JPG, TIFF)

**Supported Analyses:**
- RMSD (Root Mean Square Deviation)
- RMSF (Root Mean Square Fluctuation)
- Radius of Gyration (Rg)
- Solvent Accessible Surface Area (SASA)
- Hydrogen Bonds (H-bonds)

---

## 🔧 Installation

### Prerequisites

- **R Version:** ≥ 3.5.0 (R 4.3+ recommended)
- **Required R Packages:** ggplot2, data.table, gridExtra, scales (auto-installed)

### Install from GitHub

```r
# Install devtools if needed
if (!require("devtools")) install.packages("devtools")

# Install GROMICA
devtools::install_github("hafeez-dawar/GROMICA")

# Load package
library(GROMICA)

# Verify installation
packageVersion("GROMICA")
```

### Install from Local Files

If you have the source package:

```r
# Install from local directory
install.packages("path/to/GROMICA", repos = NULL, type = "source")

# Load package
library(GROMICA)
```

### GitHub API Rate Limit Solution

If you encounter "API rate limit exceeded" error:

```r
# Create GitHub token (opens browser)
usethis::create_github_token()

# Copy the token from browser, then:
gitcreds::gitcreds_set()
# Paste token when prompted

# Retry installation
devtools::install_github("hafeez-dawar/GROMICA")
```

---

## 🚀 Quick Start

### 3-Line Workflow

```r
library(GROMICA)
data <- read_xvg("md_rmsd.xvg")
plot_rmsd(data, color = "blue", show_stats = TRUE)
```

### Compare Multiple Trajectories

```r
library(GROMICA)
files <- c("wt_rmsd.xvg", "mutant_rmsd.xvg")
p <- compare_trajectories(files, labels = c("WT", "Mutant"), analysis_type = "rmsd")
export_plot(p, "comparison.png", dpi = 600)
```

---

## 📖 Detailed Usage

### Single Trajectory Analysis

#### 1. RMSD Analysis

**Root Mean Square Deviation - measures structural stability**

```r
library(GROMICA)

# Set working directory to where your XVG files are
setwd("/path/to/your/files")

# Read RMSD file
rmsd_data <- read_xvg("md_rmsd.xvg")

# Create basic plot
p <- plot_rmsd(rmsd_data, 
               color = "blue", 
               title = "Protein Stability Analysis")
print(p)

# Create plot with statistics overlay
p <- plot_rmsd(rmsd_data, 
               color = "blue", 
               title = "Protein Stability Analysis",
               show_stats = TRUE)
print(p)

# Export high-resolution figure
export_plot(p, "rmsd_analysis.png", dpi = 600, width = 8, height = 6)
```

**Interpretation:**
- **Low RMSD (0.1-0.2 nm):** Protein is stable
- **High RMSD (>0.5 nm):** Significant structural changes
- **Plateau in RMSD:** System has equilibrated

---

#### 2. RMSF Analysis

**Root Mean Square Fluctuation - measures residue flexibility**

```r
library(GROMICA)

# Read RMSF file (residue number vs RMSF)
rmsf_data <- read_xvg("md_rmsf.xvg")

# Create RMSF plot
p <- plot_rmsf(rmsf_data, 
               color = "red", 
               title = "Residue Flexibility Analysis")
print(p)

# With statistics
p <- plot_rmsf(rmsf_data, 
               color = "red", 
               title = "Residue Flexibility Analysis",
               show_stats = TRUE)
print(p)

# Export
export_plot(p, "rmsf_analysis.png", dpi = 600, width = 10, height = 6)
```

**Interpretation:**
- **High RMSF peaks:** Flexible regions (loops, termini)
- **Low RMSF:** Rigid regions (secondary structures)
- **Consistent RMSF:** Uniform flexibility

---

#### 3. Radius of Gyration (Rg)

**Measures protein compactness**

```r
library(GROMICA)

# Read Rg file
rg_data <- read_xvg("md_gyrate.xvg")

# Create Rg plot
p <- plot_rg(rg_data, 
             color = "green", 
             title = "Protein Compactness",
             show_stats = TRUE)
print(p)

# Export
export_plot(p, "rg_analysis.png", dpi = 600, width = 8, height = 6)
```

**Interpretation:**
- **Stable Rg:** Protein maintains compact structure
- **Increasing Rg:** Protein is unfolding
- **Decreasing Rg:** Protein is becoming more compact

---

#### 4. SASA Analysis

**Solvent Accessible Surface Area - measures surface exposure**

```r
library(GROMICA)

# Read SASA file
sasa_data <- read_xvg("md_sasa.xvg")

# Create SASA plot
p <- plot_sasa(sasa_data, 
               color = "purple", 
               title = "Surface Accessibility",
               show_stats = TRUE)
print(p)

# Export
export_plot(p, "sasa_analysis.png", dpi = 600, width = 8, height = 6)
```

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

#### Compare 2 Trajectories (Wild-type vs Mutant)

```r
library(GROMICA)

# Define files to compare
files <- c("wt_rmsd.xvg", "mutant_rmsd.xvg")

# Create comparison plot
p <- compare_trajectories(
  files = files,
  labels = c("Wild-type", "Mutant"),
  colors = c("blue", "red"),
  analysis_type = "rmsd",
  title = "RMSD: Wild-type vs Mutant",
  xlab = "Time (ns)",
  ylab = "RMSD (nm)"
)

print(p)

# Export comparison
export_plot(p, "wt_vs_mutant.png", dpi = 600, width = 10, height = 6)
```

---

#### Compare 3+ Trajectories

```r
library(GROMICA)

# Compare multiple conditions
files <- c(
  "wt_rmsd.xvg",
  "mutant1_rmsd.xvg",
  "mutant2_rmsd.xvg",
  "mutant3_rmsd.xvg"
)

p <- compare_trajectories(
  files = files,
  labels = c("Wild-type", "Mutant A", "Mutant B", "Mutant C"),
  colors = c("black", "red", "blue", "green"),
  analysis_type = "rmsd",
  title = "Effect of Mutations on Protein Stability",
  linewidth = 1.2,
  legend_position = "right"
)

print(p)
export_plot(p, "multi_mutant_comparison.png", dpi = 600, width = 12, height = 7)
```

---

#### Compare Different Analysis Types

```r
library(GROMICA)

# RMSD comparison
files <- c("wt_rmsd.xvg", "mut_rmsd.xvg")
p1 <- compare_trajectories(files, labels = c("WT", "Mut"), 
                          analysis_type = "rmsd")

# Rg comparison
files <- c("wt_gyrate.xvg", "mut_gyrate.xvg")
p2 <- compare_trajectories(files, labels = c("WT", "Mut"), 
                          analysis_type = "rg")

# SASA comparison
files <- c("wt_sasa.xvg", "mut_sasa.xvg")
p3 <- compare_trajectories(files, labels = c("WT", "Mut"), 
                          analysis_type = "sasa")

# H-bond comparison
files <- c("wt_hbond.xvg", "mut_hbond.xvg")
p4 <- compare_trajectories(files, labels = c("WT", "Mut"), 
                          analysis_type = "hbond")
```

---

## 📚 Complete Examples

### Example 1: Complete Single Protein Analysis

```r
# ═══════════════════════════════════════════════════════
#   COMPLETE MD ANALYSIS WORKFLOW
# ═══════════════════════════════════════════════════════

library(GROMICA)

# Set working directory
setwd("/path/to/md/results")

# Define file paths
protein <- "my_protein"
files <- list(
  rmsd  = paste0(protein, "_rmsd.xvg"),
  rmsf  = paste0(protein, "_rmsf.xvg"),
  rg    = paste0(protein, "_gyrate.xvg"),
  sasa  = paste0(protein, "_sasa.xvg"),
  hbond = paste0(protein, "_hbond.xvg")
)

# 1. RMSD - Stability
cat("Analyzing RMSD...\n")
rmsd <- read_xvg(files$rmsd)
p1 <- plot_rmsd(rmsd, color = "blue", show_stats = TRUE)
export_plot(p1, "01_stability.png", dpi = 600)

# 2. RMSF - Flexibility
cat("Analyzing RMSF...\n")
rmsf <- read_xvg(files$rmsf)
p2 <- plot_rmsf(rmsf, color = "red", show_stats = TRUE)
export_plot(p2, "02_flexibility.png", dpi = 600)

# 3. Rg - Compactness
cat("Analyzing Rg...\n")
rg <- read_xvg(files$rg)
p3 <- plot_rg(rg, color = "green", show_stats = TRUE)
export_plot(p3, "03_compactness.png", dpi = 600)

# 4. SASA - Surface
cat("Analyzing SASA...\n")
sasa <- read_xvg(files$sasa)
p4 <- plot_sasa(sasa, color = "purple", show_stats = TRUE)
export_plot(p4, "04_surface.png", dpi = 600)

# 5. H-bonds - Interactions
cat("Analyzing H-bonds...\n")
hbond <- read_xvg(files$hbond)
p5 <- plot_hbond(hbond, color = "darkblue", show_stats = TRUE)
export_plot(p5, "05_hbonds.png", dpi = 600)

cat("\n✅ Complete analysis finished!\n")
cat("Generated 5 publication-quality figures.\n")
```

---

### Example 2: Wild-type vs Mutant with Statistics

```r
# ═══════════════════════════════════════════════════════
#   WILD-TYPE VS MUTANT COMPARISON WITH STATISTICS
# ═══════════════════════════════════════════════════════

library(GROMICA)

# 1. Create comparison plot
files <- c("wt_rmsd.xvg", "mutant_rmsd.xvg")

p <- compare_trajectories(
  files = files,
  labels = c("Wild-type", "D362N"),
  colors = c("blue", "red"),
  analysis_type = "rmsd",
  title = "RMSD: Wild-type vs D362N Mutant"
)

print(p)

# 2. Export figures
export_plot(p, "Figure1_RMSD.png", dpi = 600, width = 10, height = 6)
export_plot(p, "Figure1_RMSD.pdf", width = 10, height = 6)

# 3. Calculate statistics
wt_data <- read_xvg("wt_rmsd.xvg")
mut_data <- read_xvg("mutant_rmsd.xvg")

cat("\n═══════════════════════════════════════\n")
cat("   STATISTICAL COMPARISON\n")
cat("═══════════════════════════════════════\n\n")

cat("WILD-TYPE:\n")
cat("  Mean RMSD:", round(mean(wt_data$Value), 3), "nm\n")
cat("  SD       :", round(sd(wt_data$Value), 3), "nm\n")
cat("  Min      :", round(min(wt_data$Value), 3), "nm\n")
cat("  Max      :", round(max(wt_data$Value), 3), "nm\n\n")

cat("D362N MUTANT:\n")
cat("  Mean RMSD:", round(mean(mut_data$Value), 3), "nm\n")
cat("  SD       :", round(sd(mut_data$Value), 3), "nm\n")
cat("  Min      :", round(min(mut_data$Value), 3), "nm\n")
cat("  Max      :", round(max(mut_data$Value), 3), "nm\n\n")

# 4. Determine stability
diff <- mean(mut_data$Value) - mean(wt_data$Value)
percent <- (diff / mean(wt_data$Value)) * 100

cat("COMPARISON:\n")
cat("  Δ Mean   :", round(diff, 3), "nm (", round(percent, 1), "%)\n", sep="")

if (diff > 0.05) {
  cat("  Status   : DESTABILIZING mutation\n")
} else if (diff < -0.05) {
  cat("  Status   : STABILIZING mutation\n")
} else {
  cat("  Status   : NEUTRAL mutation\n")
}

cat("\n═══════════════════════════════════════\n")
```

---

### Example 3: Batch Processing Multiple Files

```r
# ═══════════════════════════════════════════════════════
#   BATCH PROCESSING - ANALYZE MULTIPLE SIMULATIONS
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

### plot_rmsd()

**Create RMSD plots**

```r
plot_rmsd(data, color = "blue", title = "RMSD Analysis", 
          show_stats = FALSE, xlab = "Time (ps)", ylab = "RMSD (nm)")
```

**Parameters:**
- `data`: Data frame from read_xvg()
- `color`: Line color (default: "blue")
- `title`: Plot title
- `show_stats`: Show statistics overlay (default: FALSE)
- `xlab`: X-axis label
- `ylab`: Y-axis label

**Returns:** ggplot2 object

---

### plot_rmsf()

**Create RMSF plots**

```r
plot_rmsf(data, color = "red", title = "RMSF Analysis", 
          show_stats = FALSE, xlab = "Residue Number", ylab = "RMSF (nm)")
```

**Parameters:** Similar to plot_rmsd()

**Returns:** ggplot2 object

---

### plot_rg()

**Create Radius of Gyration plots**

```r
plot_rg(data, color = "green", title = "Radius of Gyration Analysis", 
        show_stats = FALSE, xlab = "Time (ps)", ylab = "Rg (nm)")
```

**Parameters:** Similar to plot_rmsd()

**Returns:** ggplot2 object

---

### plot_sasa()

**Create SASA plots**

```r
plot_sasa(data, color = "purple", title = "SASA Analysis", 
          show_stats = FALSE, xlab = "Time (ps)", ylab = "SASA (nm²)")
```

**Parameters:** Similar to plot_rmsd()

**Returns:** ggplot2 object

---

### plot_hbond()

**Create Hydrogen Bond plots**

```r
plot_hbond(data, color = "darkblue", title = "Hydrogen Bond Analysis", 
           show_stats = FALSE, xlab = "Time (ps)", ylab = "Number of H-bonds")
```

**Parameters:** Similar to plot_rmsd()

**Returns:** ggplot2 object

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

---

### export_plot()

**Export plots to file**

```r
export_plot(plot, filename, width = 8, height = 6, dpi = 300)
```

**Parameters:**
- `plot`: ggplot2 object to save
- `filename`: Output filename with extension
- `width`: Width in inches (default: 8)
- `height`: Height in inches (default: 6)
- `dpi`: Resolution (default: 300, max: 1200)

**Supported formats:** .png, .pdf, .svg, .jpg, .tiff

**Example:**
```r
export_plot(p, "figure1.png", dpi = 600, width = 10, height = 7)
export_plot(p, "figure1.pdf", width = 10, height = 7)
```

---

## 🔧 Troubleshooting

### Installation Issues

**Problem:** `Error: Failed to install - API rate limit exceeded`

**Solution:** Create GitHub token:
```r
usethis::create_github_token()  # Opens browser
gitcreds::gitcreds_set()         # Paste token
devtools::install_github("hafeez-dawar/GROMICA")
```

---

**Problem:** `could not find function "plot_rmsd"`

**Solution:** Load the package:
```r
library(GROMICA)
```

---

### File Reading Issues

**Problem:** `File not found`

**Solution:** Check working directory and file location:
```r
getwd()                          # Current directory
list.files(pattern = ".xvg")     # List XVG files
setwd("/path/to/files")          # Change directory
```

---

**Problem:** `No data found in file`

**Solution:** XVG file might be corrupted or empty. Check file:
```r
readLines("file.xvg", n = 25)   # View first 25 lines
```

---

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
```

### For Large Datasets

```r
# Check file size first
file.info("large_file.xvg")$size / 1e6  # Size in MB

# For very large files, consider subsampling
data <- read_xvg("large_file.xvg")
data_subset <- data[seq(1, nrow(data), by = 10), ]  # Every 10th point
```

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
Rehman, H. U. (2025). GROMICA: GROMACS Molecular Dynamics Interactive 
Computational Analysis. R package version 1.0.0. 
https://github.com/hafeez-dawar/GROMICA
```

**BibTeX:**
```bibtex
@software{gromica2025,
  author = {Rehman, Hafeez Ur},
  title = {GROMICA: GROMACS Molecular Dynamics Interactive Computational Analysis},
  year = {2025},
  publisher = {GitHub},
  url = {https://github.com/hafeez-dawar/GROMICA},
  version = {1.0.0}
}
```

---

## 📧 Support

- **Issues:** https://github.com/hafeez-dawar/GROMICA/issues
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

### Version 1.0.0 (2025-01-25)
- Initial release
- 8 core functions for MD analysis
- Single and multi-trajectory support
- Publication-quality export (up to 1200 DPI)
- Comprehensive documentation

---

**Made with ❤️ for the MD community**
