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
  
  # ------------------------------------------------------------
  # 1. VALIDATION
  # ------------------------------------------------------------
  if (length(files) < 2) stop("At least 2 files required")
  if (length(files) > 10) stop("Maximum 10 files")
  
  missing <- files[!file.exists(files)]
  if (length(missing) > 0) stop(paste("Files not found:", paste(missing, collapse = ", ")))
  
  # ------------------------------------------------------------
  # 2. SET DEFAULTS
  # ------------------------------------------------------------
  if (is.null(labels)) labels <- paste("Trajectory", seq_along(files))
  if (is.null(colors)) {
    default_colors <- c("blue", "red", "green", "purple", "orange", 
                       "brown", "pink", "gray", "cyan", "darkgreen")
    colors <- default_colors[seq_along(files)]
  }
  
  # ------------------------------------------------------------
  # 3. BULLETPROOF ANALYSIS TYPE DETECTION
  # ------------------------------------------------------------
  if (is.null(analysis_type)) {
    # STEP 1: Check filenames (MOST RELIABLE for your case)
    all_filenames <- paste(basename(files), collapse = " ")
    
    if (grepl("gyrate", all_filenames, ignore.case = TRUE)) {
      analysis_type <- "rg"
      cat("DEBUG: Detected 'gyrate' in filenames -> analysis_type = 'rg'\n")
    }
    # STEP 2: If filename doesn't help, check file headers
    else {
      # Read first file with headers preserved
      data1 <- read_xvg(files[1])
      headers <- attr(data1, "headers")
      
      if (!is.null(headers)) {
        header_text <- paste(headers, collapse = " ")
        
        if (grepl("radius of gyration", header_text, ignore.case = TRUE)) {
          analysis_type <- "rg"
          cat("DEBUG: Detected 'radius of gyration' in headers -> analysis_type = 'rg'\n")
        } else if (grepl("rmsd", header_text, ignore.case = TRUE)) {
          analysis_type <- "rmsd"
        } else if (grepl("rmsf", header_text, ignore.case = TRUE)) {
          analysis_type <- "rmsf"
        } else if (grepl("sasa", header_text, ignore.case = TRUE)) {
          analysis_type <- "sasa"
        } else if (grepl("hbond", header_text, ignore.case = TRUE)) {
          analysis_type <- "hbond"
        }
      }
      
      # STEP 3: If still not detected, check data values
      if (is.null(analysis_type)) {
        y_mean <- mean(data1[, 2], na.rm = TRUE)
        
        # Rg values are typically 2-4 nm, RMSD is 0-2 nm
        if (y_mean > 1.8 && y_mean < 5.0) {
          analysis_type <- "rg"
          cat("DEBUG: Data mean =", y_mean, "-> analysis_type = 'rg'\n")
        } else {
          analysis_type <- "rmsd"
          cat("DEBUG: Data mean =", y_mean, "-> analysis_type = 'rmsd'\n")
        }
      }
    }
  }
  
  # ------------------------------------------------------------
  # 4. FINAL OVERRIDE: If ANY file has "gyrate", FORCE it to be Rg
  # ------------------------------------------------------------
  if (any(grepl("gyrate", basename(files), ignore.case = TRUE))) {
    analysis_type <- "rg"
    cat("DEBUG: FINAL OVERRIDE -> analysis_type = 'rg'\n")
  }
  
  # ------------------------------------------------------------
  # 5. SET AXIS LABELS AND TITLE
  # ------------------------------------------------------------
  if (is.null(xlab)) {
    xlab <- if (analysis_type == "rmsf") "Residue Number" else "Time (ns)"
  }
  
  if (is.null(ylab)) {
    ylab <- switch(analysis_type,
                   rmsd = "RMSD (nm)",
                   rmsf = "RMSF (nm)",
                   rg = "Rg (nm)",
                   sasa = "SASA (nm²)",
                   hbond = "Number of H-bonds",
                   "Value")
    cat("DEBUG: ylab set to:", ylab, "\n")
  }
  
  if (is.null(title)) {
    title <- switch(analysis_type,
                   rmsd = "RMSD Comparison",
                   rmsf = "RMSF Comparison",
                   rg = "Radius of Gyration Comparison",
                   sasa = "SASA Comparison",
                   hbond = "Hydrogen Bond Comparison",
                   "Trajectory Comparison")
  }
  
  # ------------------------------------------------------------
  # 6. READ AND COMBINE DATA
  # ------------------------------------------------------------
  combined <- data.frame()
  for (i in seq_along(files)) {
    temp <- read_xvg(files[i])
    
    # Use only first two columns (Time and Value)
    temp_df <- data.frame(
      X = temp[, 1],
      Y = temp[, 2],
      Trajectory = labels[i]
    )
    
    combined <- rbind(combined, temp_df)
  }
  
  combined$Trajectory <- factor(combined$Trajectory, levels = labels)
  
  # ------------------------------------------------------------
  # 7. CREATE PLOT
  # ------------------------------------------------------------
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
