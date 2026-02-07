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
  
  # FIXED: Auto-detect analysis_type from ALL files, not just first
  if (is.null(analysis_type)) {
    # Check ALL files for analysis type patterns
    detected_types <- sapply(files, .detect_analysis_type)
    
    # Get most common type among all files
    type_counts <- table(detected_types)
    most_common <- names(type_counts)[which.max(type_counts)]
    
    # Use the most common type, or default to first if ambiguous
    if (most_common != "unknown" && length(type_counts) > 0) {
      analysis_type <- most_common
    } else {
      # If all unknown, check file contents of first file
      analysis_type <- .detect_from_file_content(files[1])
    }
    
    # If still unknown, default based on filename pattern
    if (analysis_type == "unknown") {
      # Check if ANY file has "gyrate" in the name
      if (any(grepl("gyrate|rg", files, ignore.case = TRUE))) {
        analysis_type <- "rg"
      } else if (any(grepl("rmsd", files, ignore.case = TRUE))) {
        analysis_type <- "rmsd"
      } else if (any(grepl("rmsf", files, ignore.case = TRUE))) {
        analysis_type <- "rmsf"
      } else {
        analysis_type <- "rmsd"  # Ultimate fallback
      }
    }
  }
  
  # Set default axis labels if not provided
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
  }
  
  # Set default title if not provided
  if (is.null(title)) {
    title <- switch(analysis_type,
                   rmsd = "RMSD Comparison",
                   rmsf = "RMSF Comparison",
                   rg = "Radius of Gyration Comparison",
                   sasa = "SASA Comparison",
                   hbond = "Hydrogen Bond Comparison",
                   "Trajectory Comparison")
  }
  
  # Read and combine data from all files
  combined <- data.frame()
  for (i in seq_along(files)) {
    temp <- read_xvg(files[i])
    temp$Trajectory <- labels[i]
    colnames(temp)[1:2] <- c("X", "Y")
    combined <- rbind(combined, temp)
  }
  
  combined$Trajectory <- factor(combined$Trajectory, levels = labels)
  
  # Create plot
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

#' Helper function to detect analysis type from filename
#' @param file_path Path to the file
#' @return Analysis type as string
#' @noRd
.detect_analysis_type <- function(file_path) {
  filename <- basename(file_path)
  filename_lower <- tolower(filename)
  
  if (grepl("gyrate|rg|radius", filename_lower)) {
    return("rg")
  } else if (grepl("rmsd", filename_lower)) {
    return("rmsd")
  } else if (grepl("rmsf", filename_lower)) {
    return("rmsf")
  } else if (grepl("sasa", filename_lower)) {
    return("sasa")
  } else if (grepl("hbond|hydrogen", filename_lower)) {
    return("hbond")
  } else {
    return("unknown")
  }
}

#' Helper function to detect analysis type from file content
#' @param file_path Path to the file
#' @return Analysis type as string
#' @noRd
.detect_from_file_content <- function(file_path) {
  tryCatch({
    # Read first few lines to check for headers
    con <- file(file_path, "r")
    first_lines <- readLines(con, n = 20)
    close(con)
    
    # Check for @ lines in .xvg files
    for (line in first_lines) {
      line_lower <- tolower(line)
      
      # Check for gyrate/Rg indicators
      if (grepl("@.*title.*gyrat", line_lower) || 
          grepl("@.*ylabel.*rg", line_lower) ||
          grepl("@ s[0-9].*legend.*rg", line_lower) ||
          grepl("radius of gyration", line_lower)) {
        return("rg")
      }
      
      # Check for RMSD indicators
      if (grepl("@.*title.*rmsd", line_lower) || 
          grepl("@.*ylabel.*rmsd", line_lower) ||
          grepl("root mean square deviation", line_lower)) {
        return("rmsd")
      }
      
      # Check for RMSF indicators
      if (grepl("@.*title.*rmsf", line_lower) || 
          grepl("@.*ylabel.*rmsf", line_lower) ||
          grepl("root mean square fluctuation", line_lower)) {
        return("rmsf")
      }
    }
  }, error = function(e) {
    # If file reading fails, return unknown
  })
  
  return("unknown")
}
