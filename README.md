# GROMICA: GROMACS Molecular Dynamics Visualization

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## Overview

**GROMICA** is an R package for visualizing and analyzing GROMACS molecular dynamics simulation results. It provides easy-to-use functions for creating publication-quality plots.

### Features

- ✨ Easy to use - Simple, intuitive functions
- 📊 Multiple analyses - RMSD, RMSF, and more
- 🎨 Customizable plots - Colors, labels, styles
- 💎 Publication quality - Export up to 1200 DPI
- 🌐 Web application - Also available at https://hafeez-dawar-gromica.hf.space

## Installation

```r
# Install from GitHub
install.packages("devtools")
devtools::install_github("hafeez-dawar/GROMICA")
```

## Quick Start

```r
library(GROMICA)

# Read GROMACS XVG file
data <- read_xvg("md_rmsd.xvg")

# Create RMSD plot
plot_rmsd(data, color = "blue", show_stats = TRUE)

# Export high-resolution plot
p <- plot_rmsd(data)
export_plot(p, "rmsd_plot.png", dpi = 600)
```

## Available Functions

### Data Import
- `read_xvg()` - Read GROMACS XVG files

### Plotting Functions
- `plot_rmsd()` - Root Mean Square Deviation plots
- `plot_rmsf()` - Root Mean Square Fluctuation plots

### Utilities
- `export_plot()` - Save plots in various formats (up to 1200 DPI)

## Usage Examples

### RMSD Analysis

```r
# Basic RMSD plot
data <- read_xvg("md_rmsd.xvg")
p <- plot_rmsd(data, color = "blue")
print(p)

# With statistics
p <- plot_rmsd(data, show_stats = TRUE)
print(p)
```

### RMSF Analysis

```r
# Read RMSF data
rmsf_data <- read_xvg("md_rmsf.xvg", col.names = c("Residue", "RMSF"))

# Plot
plot_rmsf(rmsf_data, color = "red", title = "Protein Flexibility")
```

### Export Options

```r
# Export as PNG (default 300 DPI)
export_plot(p, "plot.png")

# High-resolution PNG for publication
export_plot(p, "plot_hires.png", dpi = 1200, width = 7, height = 5)

# Vector PDF for journals
export_plot(p, "plot.pdf", width = 8, height = 6)
```

## Web Application

GROMICA is also available as a free web application:

🌐 **Web App:** https://hafeez-dawar-gromica.hf.space  
📄 **Landing Page:** https://hafeez-dawar.github.io/GROMICA/

## Citation

If you use GROMICA in your research, please cite:

```bibtex
@software{gromica2025,
  author = {Rehman, Hafeez Ur},
  title = {GROMICA: GROMACS Molecular Dynamics Visualization and Analysis},
  year = {2025},
  publisher = {GitHub},
  url = {https://github.com/hafeez-dawar/GROMICA}
}
```

## Requirements

- R (>= 3.5.0)
- ggplot2 (>= 3.3.0)
- data.table (>= 1.12.0)
- gridExtra (>= 2.3)
- scales (>= 1.1.0)

## License

GPL-3

## Contact

**Hafeez Ur Rehman**  
Northwest A&F University  
Email: hafeez@nwafu.edu.cn  
GitHub: [@hafeez-dawar](https://github.com/hafeez-dawar)

---

**Made with ❤️ for the computational chemistry community**
