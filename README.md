# GROMICA: GROMACS Molecular Dynamics Visualization

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## 🌐 Web Application

**Try GROMICA now - no installation required!**

🚀 **Live Demo:** https://hafeez-dawar-gromica.hf.space  
📄 **Landing Page:** https://hafeez-dawar.github.io/GROMICA/

---

## 📦 R Package

**For programmatic access and reproducible research workflows**

### Installation
```r
# Install from GitHub
install.packages("devtools")
devtools::install_github("hafeez-dawar/GROMICA")
```

### Quick Start
```r
library(GROMICA)

# Read GROMACS XVG file
data <- read_xvg("md_rmsd.xvg")

# Create RMSD plot
plot_rmsd(data, color = "blue", show_stats = TRUE)

# Export high-resolution
export_plot(last_plot(), "rmsd.png", dpi = 600)
```

---

## ✨ Features

### Web Application
- ✅ No installation required - runs in browser
- ✅ Drag-and-drop file upload
- ✅ Interactive visualization
- ✅ Multi-format export (PNG, PDF, SVG)

### R Package
- ✅ Programmatic access
- ✅ Batch processing
- ✅ Reproducible workflows
- ✅ Integration with R ecosystem

### Analyses Supported
- 📈 RMSD - Root Mean Square Deviation
- 📊 RMSF - Root Mean Square Fluctuation
- 🔵 Radius of Gyration
- 💧 SASA - Solvent Accessible Surface Area
- 🔗 Hydrogen Bond Analysis

---

## 📖 Documentation

### R Package Functions

#### Data Import
```r
read_xvg(file)  # Read GROMACS XVG files
```

#### Plotting
```r
plot_rmsd(data, color = "blue", show_stats = TRUE)
plot_rmsf(data, color = "red")
```

#### Export
```r
export_plot(plot, filename, dpi = 600)
```

### Examples

**RMSD Analysis:**
```r
# Load package
library(GROMICA)

# Read data
rmsd_data <- read_xvg("md_rmsd.xvg")

# Create plot
p <- plot_rmsd(rmsd_data, 
               color = "blue",
               title = "Protein Stability",
               show_stats = TRUE)

# Export for publication
export_plot(p, "figure1.png", dpi = 1200, width = 7, height = 5)
```

**RMSF Analysis:**
```r
rmsf_data <- read_xvg("md_rmsf.xvg", col.names = c("Residue", "RMSF"))
plot_rmsf(rmsf_data, color = "red", title = "Residue Flexibility")
```

---

## 🎓 Citation

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

---

## 🛠️ Requirements

### Web Application
- Modern web browser (Chrome, Firefox, Safari, Edge)
- Internet connection

### R Package
- R (≥ 3.5.0)
- ggplot2 (≥ 3.3.0)
- data.table (≥ 1.12.0)
- gridExtra (≥ 2.3)
- scales (≥ 1.1.0)

---

## 📂 Repository Structure
```
GROMICA/
├── index.html          # Landing page
├── sitemap.xml         # SEO sitemap
├── robots.txt          # Search engine instructions
├── DESCRIPTION         # R package metadata
├── NAMESPACE           # R package exports
├── LICENSE.md          # GPL-3.0 License
└── R/                  # R package functions
    ├── read_xvg.R
    ├── plot_rmsd.R
    ├── plot_rmsf.R
    └── export_plot.R
```

---

## 📝 License

GPL-3.0

---

## 👨‍💻 Author

**Hafeez Ur Rehman**  
Northwest A&F University  
📧 hafeez@nwafu.edu.cn  
🔗 GitHub: [@hafeez-dawar](https://github.com/hafeez-dawar)

---

## 🌟 Acknowledgments

Made with ❤️ for the computational chemistry and bioinformatics community

---

**Choose your interface:**
- 🌐 Quick analysis → [Web App](https://hafeez-dawar-gromica.hf.space)
- 💻 Reproducible research → R Package (`devtools::install_github("hafeez-dawar/GROMICA")`)