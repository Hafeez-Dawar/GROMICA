#' Compare Multiple Trajectories
#'
#' Compares multiple GROMACS simulation trajectories on a single plot.
#' Supports RMSD, RMSF, Rg, SASA, and H-bond analyses.
#'
#' @param files Character vector of file paths (2-10 XVG files)
#' @param labels Character vector of labels for each trajectory (optional)
#' @param colors Character vector of colors for each trajectory (optional)
#' @param analysis_type Type of analysis: "rmsd", "rmsf", "rg", "sasa", or "hbond" (default: "rmsd")
#' @param title Custom plot title (optional, auto-generated if NULL)
#' @param xlab X-axis label (optional, auto-generated based on analysis_type)
#' @param ylab Y-axis label (optional, auto-generated based on analysis_type)
#' @param linewidth Line width (default: 1)
#' @param legend_position Legend position: "right", "left", "top", "bottom", or "none" (default: "right")
#'
#' @return A ggplot2 object with all trajectories
#'
#' @examples
#' \dontrun{
#' files <- c("wt_rmsd.xvg", "mut1_rmsd.xvg", "mut2_rmsd.xvg")
#' labels <- c("Wild-type", "Mutant 1", "Mutant 2")
#' compare_trajectories(files, labels = labels, analysis_type = "rmsd")
#' }
#'
#' @export
#' @importFrom ggplot2 ggplot aes geom_line labs theme_classic theme element_text scale_color_manual
compare_trajectories <- function(files,
                                 labels = NULL,
                                 colors = NULL,
                                 analysis_type = "rmsd",
                                 title = NULL,
                                 xlab = NULL,
                                 ylab = NULL,
                                 linewidth = 1,
                                 legend_position = "right") {
  
  # Validate inputs
  if (length(files) < 2) {
    stop("At least 2 files are required for comparison")
  }
  
  if (length(files) > 10) {
    stop("Maximum 10 files can be compared at once")
  }
  
  # Check if all files exist
  missing_files <- files[!file.exists(files)]
  if (length(missing_files) > 0) {
    stop(paste("File(s) not found:", paste(missing_files, collapse = ", ")))
  }
  
  # Generate default labels if not provided
  if (is.null(labels)) {
    labels <- paste("Trajectory", 1:length(files))
  } else if (length(labels) != length(files)) {
    stop("Number of labels must match number of files")
  }
  
  # Generate default colors if not provided
  if (is.null(colors)) {
    colors <- c("blue", "red", "green", "purple", "orange", 
                "brown", "pink", "gray", "cyan", "darkgreen")[1:length(files)]
  } else if (length(colors) != length(files)) {
    stop("Number of colors must match number of files")
  }
  
  # Set default axis labels based on analysis type
  if (is.null(xlab)) {
    xlab <- if (analysis_type == "rmsf") "Residue Number" else "Time (ps)"
  }
  
  if (is.null(ylab)) {
    ylab <- switch(analysis_type,
                   "rmsd" = "RMSD (nm)",
                   "rmsf" = "RMSF (nm)",
                   "rg" = "Rg (nm)",
                   "sasa" = "SASA (nm²)",
                   "hbond" = "Number of H-bonds",
                   "Value")
  }
  
  # Set default title based on analysis type
  if (is.null(title)) {
    title <- switch(analysis_type,
                    "rmsd" = "RMSD Comparison",
                    "rmsf" = "RMSF Comparison",
                    "rg" = "Radius of Gyration Comparison",
                    "sasa" = "SASA Comparison",
                    "hbond" = "Hydrogen Bond Comparison",
                    "Trajectory Comparison")
  }
  
  # Read all files and combine
  combined_data <- data.frame()
  
  for (i in 1:length(files)) {
    # Read XVG file
    temp_data <- read_xvg(files[i])
    
    # Add trajectory label
    temp_data$Trajectory <- labels[i]
    
    # Rename columns
    if (ncol(temp_data) >= 3) {
      colnames(temp_data)[1:2] <- c("X", "Y")
    } else {
      stop(paste("File", files[i], "does not have enough columns"))
    }
    
    # Combine
    combined_data <- rbind(combined_data, temp_data)
  }
  
  # Convert Trajectory to factor with specified order
  combined_data$Trajectory <- factor(combined_data$Trajectory, levels = labels)
  
  # Create plot
  p <- ggplot2::ggplot(combined_data, ggplot2::aes(x = X, y = Y, color = Trajectory)) +
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
      plot.title = ggplot2::element_text(hjust = 0.5, size = 14, face = "bold"),
      axis.title = ggplot2::element_text(size = 12),
      axis.text = ggplot2::element_text(size = 10),
      legend.position = legend_position,
      legend.title = ggplot2::element_text(size = 11, face = "bold"),
      legend.text = ggplot2::element_text(size = 10)
    )
  
  return(p)
}
