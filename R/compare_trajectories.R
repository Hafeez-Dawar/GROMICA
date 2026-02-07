#' Compare Multiple Trajectories
#'
#' @param files Character vector of file paths
#' @param labels Character vector of labels (optional)
#' @param colors Character vector of colors (optional)
#' @param analysis_type Type: "rmsd", "rmsf", "rg", "sasa", "hbond" (optional)
#' @param title Plot title (optional)
#' @param xlab X-axis label (optional)
#' @param ylab Y-axis label (optional)
#' @param linewidth Line width (default: 1)
#' @param legend_position Legend position (default: "right")
#' @return ggplot2 object
#' @export
#' @importFrom ggplot2 ggplot aes geom_line labs theme_classic theme element_text scale_color_manual
compare_trajectories <- function(files, labels = NULL, colors = NULL, 
                                 analysis_type = NULL, title = NULL, 
                                 xlab = NULL, ylab = NULL, linewidth = 1, 
                                 legend_position = "right") {
  
  # ============================================================
  # VALIDATION
  # ============================================================
  if (length(files) < 2) stop("At least 2 files required")
  if (length(files) > 10) stop("Maximum 10 files")
  
  missing <- files[!file.exists(files)]
  if (length(missing) > 0) stop(paste("Files not found:", paste(missing, collapse = ", ")))
  
  # ============================================================
  # AUTO-DETECT ANALYSIS TYPE FROM FIRST FILE (if not specified)
  # ============================================================
  
  if (is.null(analysis_type)) {
    # Read first file to detect data pattern
    first_data <- read_xvg(files[1])
    
    # Check data characteristics to determine type
    if (ncol(first_data) >= 2) {
      x_vals <- first_data[, 1]
      y_vals <- first_data[, 2]
      
      # Check if it's RMSF (residue-based data)
      # RMSF typically has integer residue numbers and values around 0.1-1.0 nm
      is_rmsf <- all(x_vals == round(x_vals)) && 
                 all(y_vals >= 0) && all(y_vals <= 5) &&
                 length(x_vals) > 10  # More than 10 residues
      
      # Check if it's Rg data (gyrate files)
      # Rg values typically between 1-10 nm
      is_rg <- all(y_vals >= 0.5) && all(y_vals <= 20) && 
               grepl("gyrate", basename(files[1]), ignore.case = TRUE)
      
      # Check if it's SASA data
      # SASA values typically between 0-1000 nm²
      is_sasa <- all(y_vals >= 0) && all(y_vals <= 2000) &&
                 grepl("sasa", basename(files[1]), ignore.case = TRUE)
      
      # Check if it's RMSD data
      # RMSD typically starts at 0 and increases
      is_rmsd <- y_vals[1] < 0.5 && max(y_vals) > 0.5 &&
                 grepl("rmsd", basename(files[1]), ignore.case = TRUE)
      
      # Check if it's HBond data
      # HBond counts are typically integers
      is_hbond <- all(y_vals == round(y_vals)) && 
                  all(y_vals >= 0) && all(y_vals <= 100) &&
                  grepl("hbond|hbnum", basename(files[1]), ignore.case = TRUE)
      
      # Determine analysis type based on checks
      if (is_rmsf) {
        analysis_type <- "rmsf"
      } else if (is_rg) {
        analysis_type <- "rg"
      } else if (is_sasa) {
        analysis_type <- "sasa"
      } else if (is_hbond) {
        analysis_type <- "hbond"
      } else if (is_rmsd) {
        analysis_type <- "rmsd"
      } else {
        # Try filename pattern as fallback
        fname <- tolower(basename(files[1]))
        if (grepl("rmsf", fname)) {
          analysis_type <- "rmsf"
        } else if (grepl("gyrate|rg", fname)) {
          analysis_type <- "rg"
        } else if (grepl("sasa", fname)) {
          analysis_type <- "sasa"
        } else if (grepl("hbond|hbnum", fname)) {
          analysis_type <- "hbond"
        } else if (grepl("rmsd", fname)) {
          analysis_type <- "rmsd"
        } else {
          analysis_type <- "rmsd"  # Default fallback
          warning("Could not auto-detect analysis type. Defaulting to 'rmsd'. Specify 'analysis_type' parameter to avoid this.")
        }
      }
    } else {
      analysis_type <- "rmsd"  # Default fallback
    }
  }
  
  # ============================================================
  # SET DEFAULTS BASED ON ANALYSIS TYPE
  # ============================================================
  if (is.null(labels)) labels <- paste("Trajectory", seq_along(files))
  if (is.null(colors)) {
    default_colors <- c("blue", "red", "green", "purple", "orange", 
                       "brown", "pink", "gray", "cyan", "darkgreen")
    colors <- default_colors[seq_along(files)]
  }
  
  # Set x-axis label
  if (is.null(xlab)) {
    xlab <- if (analysis_type == "rmsf") "Residue Number" else "Time (ns)"
  }
  
  # Set y-axis label
  if (is.null(ylab)) {
    ylab <- switch(analysis_type,
                   rmsd = "RMSD (nm)",
                   rmsf = "RMSF (nm)",
                   rg = "Rg (nm)",
                   sasa = "SASA (nm²)",
                   hbond = "Number of H-bonds",
                   "Value")
  }
  
  # Set title
  if (is.null(title)) {
    title <- switch(analysis_type,
                   rmsd = "RMSD Comparison",
                   rmsf = "RMSF Comparison",
                   rg = "Radius of Gyration Comparison",
                   sasa = "SASA Comparison",
                   hbond = "Hydrogen Bond Comparison",
                   "Trajectory Comparison")
  }
  
  # ============================================================
  # READ AND COMBINE DATA
  # ============================================================
  combined <- data.frame()
  for (i in seq_along(files)) {
    temp <- read_xvg(files[i])
    temp_df <- data.frame(
      X = temp[, 1],
      Y = temp[, 2],
      Trajectory = labels[i]
    )
    combined <- rbind(combined, temp_df)
  }
  
  combined$Trajectory <- factor(combined$Trajectory, levels = labels)
  
  # ============================================================
  # CREATE PLOT
  # ============================================================
  p <- ggplot2::ggplot(combined, ggplot2::aes(x = X, y = Y, color = Trajectory)) +
    ggplot2::geom_line(linewidth = linewidth) +
    ggplot2::scale_color_manual(values = setNames(colors, labels)) +
    ggplot2::labs(title = title, x = xlab, y = ylab, color = "Trajectory") +
    ggplot2::theme_classic() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(hjust = 0.5, size = 14, face = "bold"),
      legend.position = legend_position
    )
  
  return(p)
}
