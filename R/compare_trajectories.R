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
  
  # Validate inputs
  if (length(files) < 2) stop("At least 2 files required")
  if (length(files) > 10) stop("Maximum 10 files")
  
  missing <- files[!file.exists(files)]
  if (length(missing) > 0) stop(paste("Files not found:", paste(missing, collapse = ", ")))
  
  # Set default labels if not provided
  if (is.null(labels)) labels <- paste("Trajectory", seq_along(files))
  if (is.null(colors)) {
    default_colors <- c("blue", "red", "green", "purple", "orange", 
                       "brown", "pink", "gray", "cyan", "darkgreen")
    colors <- default_colors[seq_along(files)]
  }
  
  # ------------------------------------------------------------
  # CRITICAL FIX: Detect analysis type PROPERLY
  # ------------------------------------------------------------
  if (is.null(analysis_type)) {
    # Get all filenames in lowercase
    all_filenames <- tolower(paste(basename(files), collapse = " "))
    
    # Priority 1: Check for "gyrate" or "rg" in ANY filename
    if (grepl("gyrate|rg", all_filenames)) {
      analysis_type <- "rg"
    } 
    # Priority 2: Check file content headers
    else {
      # Read first file's headers
      con <- file(files[1], "r")
      headers <- readLines(con, n = 15)
      close(con)
      
      # Look for "radius of gyration" in headers
      header_text <- tolower(paste(headers, collapse = " "))
      
      if (grepl("radius of gyration|radius \\(nm\\)|@.*title.*gyrat", header_text)) {
        analysis_type <- "rg"
      } else if (grepl("rmsd|root mean square deviation", header_text)) {
        analysis_type <- "rmsd"
      } else if (grepl("rmsf|root mean square fluctuation", header_text)) {
        analysis_type <- "rmsf"
      } else if (grepl("sasa|solvent accessible", header_text)) {
        analysis_type <- "sasa"
      } else if (grepl("hbond|hydrogen bond", header_text)) {
        analysis_type <- "hbond"
      } else {
        # Default based on data values
        data <- read_xvg(files[1])
        y_mean <- mean(data[, 2], na.rm = TRUE)
        
        # Rg values are typically 2-4 nm, RMSD is 0-2 nm
        if (y_mean > 1.8 && y_mean < 5.0) {
          analysis_type <- "rg"
        } else {
          analysis_type <- "rmsd"  # Default fallback
        }
      }
    }
  }
  
  # ------------------------------------------------------------
  # Set default axis labels if not provided
  # ------------------------------------------------------------
  if (is.null(xlab)) {
    xlab <- if (analysis_type == "rmsf") "Residue Number" else "Time (ns)"
  }
  
  if (is.null(ylab)) {
    ylab <- switch(analysis_type,
                   rmsd = "RMSD (nm)",
                   rmsf = "RMSF (nm)",
                   rg = "Rg (nm)",            # This WILL be used for gyrate files
                   sasa = "SASA (nm²)",
                   hbond = "Number of H-bonds",
                   "Value")
  }
  
  # ------------------------------------------------------------
  # Set default title if not provided
  # ------------------------------------------------------------
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
  # Read and combine data from all files
  # ------------------------------------------------------------
  combined <- data.frame()
  for (i in seq_along(files)) {
    # Read the file
    temp <- read_xvg(files[i])
    
    # For Rg files, use only Time (col1) and Total Rg (col2)
    # Other files use first two columns
    temp_df <- data.frame(
      X = temp[, 1],          # Time or Residue Number
      Y = temp[, 2],          # Main value (Rg, RMSD, etc.)
      Trajectory = labels[i]
    )
    
    combined <- rbind(combined, temp_df)
  }
  
  # Factorize trajectory labels to maintain order
  combined$Trajectory <- factor(combined$Trajectory, levels = labels)
  
  # ------------------------------------------------------------
  # Create the plot
  # ------------------------------------------------------------
  p <- ggplot2::ggplot(combined, ggplot2::aes(x = X, y = Y, color = Trajectory)) +
    ggplot2::geom_line(linewidth = linewidth) +
    ggplot2::scale_color_manual(values = setNames(colors, labels)) +
    ggplot2::labs(
      title = title,
      x = xlab,
      y = ylab,
      color = "Trajectory"
    ) +
    ggplot2::theme_classic() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(
        hjust = 0.5,
        size = 14,
        face = "bold"
      ),
      legend.position = legend_position
    )
  
  return(p)
}
