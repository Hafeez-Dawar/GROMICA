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
  # AUTO-DETECT Rg FOR GYRATE FILES
  # ============================================================
  
  # Check if ANY file has "gyrate" in the name
  has_gyrate <- any(grepl("gyrate", basename(files), ignore.case = TRUE))
  
  if (has_gyrate && is.null(analysis_type)) {
    # Auto-set for gyrate files
    analysis_type <- "rg"
    if (is.null(ylab)) ylab <- "Rg (nm)"
    if (is.null(xlab)) xlab <- "Time (ns)"
  }
  
  # ============================================================
  # VALIDATION
  # ============================================================
  if (length(files) < 2) stop("At least 2 files required")
  if (length(files) > 10) stop("Maximum 10 files")
  
  missing <- files[!file.exists(files)]
  if (length(missing) > 0) stop(paste("Files not found:", paste(missing, collapse = ", ")))
  
  # ============================================================
  # SET DEFAULTS
  # ============================================================
  if (is.null(labels)) labels <- paste("Trajectory", seq_along(files))
  if (is.null(colors)) {
    default_colors <- c("blue", "red", "green", "purple", "orange", 
                       "brown", "pink", "gray", "cyan", "darkgreen")
    colors <- default_colors[seq_along(files)]
  }
  
  if (is.null(analysis_type)) analysis_type <- "rmsd"
  
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
