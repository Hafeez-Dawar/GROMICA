# GROMICA

**GROMACS Molecular Dynamics Interactive Computational Analysis**

A comprehensive R package for analyzing and visualizing GROMACS molecular dynamics simulation results.

## Installation

```r
devtools::install_github("hafeez-dawar/GROMICA")
```

## Quick Start

```r
library(GROMICA)

# Single trajectory analysis
data <- read_xvg("rmsd.xvg")
plot_rmsd(data, color = "blue", show_stats = TRUE)

# Multi-trajectory comparison
files <- c("wt_rmsd.xvg", "mut_rmsd.xvg")
compare_trajectories(files, labels = c("WT", "Mutant"), analysis_type = "rmsd")

# Export high-resolution figure
export_plot(last_plot(), "figure.png", dpi = 600)
```

## Features

- **8 Core Functions:**
  - `read_xvg()` - Import GROMACS XVG files
  - `plot_rmsd()` - RMSD analysis
  - `plot_rmsf()` - RMSF analysis
  - `plot_rg()` - Radius of Gyration
  - `plot_sasa()` - Solvent Accessible Surface Area
  - `plot_hbond()` - Hydrogen Bond analysis
  - `compare_trajectories()` - Multi-trajectory comparison
  - `export_plot()` - Save publication-quality figures

- **Publication-Ready Output:**
  - High-resolution export (up to 1200 DPI)
  - Multiple formats (PNG, PDF, SVG)
  - Professional styling

## License

GPL-3

## Author

Hafeez Ur Rehman (hafeez@nwafu.edu.cn)
